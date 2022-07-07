module AllExtensions
using Toolips
using ToolipsSession
using ToolipsDefaults
using ToolipsUploader
using ToolipsBase64
using ToolipsMarkdown
using ToolipsMarkdown: @tmd_str

#==
Toolips
    Overview
==#
greet_tmd = tmd"""# Toolips Extension Gallery
Hello, welcome to the toolips extension gallery! This website demonstrates the
capabilities of all the toolips extensions that are currently curated. Feel free
to browse the amazing Components and capabilities that are available with each
extension! **more coming soon !**
#### jump to:
- [ToolipsSession](#)
- [ToolipsMarkdown](#)
- [ToolipsDefaults](#)
- [ToolipsBase64](#)
- [ToolipsUploader](#)
- [ToolipsRemote](#)
"""

greet_tmd["align"] = "left"
style!(greet_tmd, "margin-left" => "50px")
tllogo = img("tllogo", src = "toolips/toolipsapp.png")
#==
Toolips
    Markdown
==#
markdown_logo = img("markdownlogo", src = "toolips/toolipsmarkdown.png", width = 300)
markdown_tmd = tmd"""# Markdown
hello world"""
#==
Toolips
    Uploader
==#
uploader_logo = img("uploaderlogo", src = "toolips/toolipsuploader.png", width = 200)
uploader_vlink = tmd"""[![version](https://juliahub.com/docs/Toolips/version.svg)](https://juliahub.com/ui/Packages/Toolips/TrAr4)"""
uploader_tmd = tmd"""# Uploader
The toolips uploader extension makes it incredibly easy to upload and work with
files from a client's machine. Below is an example where you can upload a
markdown file, and the markdown file is prompty returned into a divider with
toolips markdown."""
"""
home(c::Connection) -> _
--------------------
The home function is served as a route inside of your server by default. To
    change this, view the start method below.
"""
function home(c::Connection)
    # Styles
    styles = stylesheet()
    styles["div"]["background-color"] = "white"
    styles["div"]["padding"] = "20px"
    styles["div"]["margin"] = "10px"
    styles["a"]["color"] = "lightblue"
    styles["p"]["color"] = "darkgray"
    sections = Style("section", padding = "30px")
    sections["border-color"] = "gray"
    sections["border-width"] = "2px"
    sections["border-radius"] = "10px"
    sections["border-style"] = "solid"
    sections["background-color"] = "white"
    push!(styles, sections)
    write!(c, styles)
    #==
    Overview
    ==#
    overview = section("overviewsection")
    push!(overview, tllogo, greet_tmd)
    #==
    Markdown
    ==#
    markdownsection = section("markdownsection")
    markdownviewer = divider("mdcreator", align = "left")
    style!(markdownviewer, "background-color" => "white", "border-style" => "solid",
    "border-width" => "2px", "border-color" => "gray", "border-radius" => "10px",
     "transition" => "1s")
    mdbox = divider("mdbox", contenteditable = true, text = "# ToolipsMarkdown Example",
    align = "left")
    style!(mdbox, "border-width" => "1px", "border-color" => "orange", "border-style" => "dashed",
    "display" => "inline-block", "overflow-y" => "scroll", "width" => "500px",
    "height" => "200px")
    tmdbox = divider("tmdbox")
    style!(tmdbox, "border-width" => "1px", "border-color" => "orange", "border-style" => "dashed",
    "display" => "inline-block", "overflow-y" => "scroll", "width" => "900px",
    "height" => "200px")
    push!(tmdbox, tmd("mytmd", "# ToolipsMarkdown Example"))
    on(c, mdbox, "keydown") do cm::ComponentModifier
        input = cm[mdbox]["text"]
        set_children!(cm, tmdbox, components(tmd("mytmd", input)))
    end
    push!(markdownviewer, mdbox, tmdbox)
    push!(markdownsection, markdown_logo, markdown_tmd, markdownviewer)
    #==
    Uploader
    ==#
    uploadersection = section("uploadersection")
    uploaderbox = divider("uploaderbox")
    style!(uploaderbox, "background-color" => "white", "border-style" => "solid",
    "border-width" => "2px", "border-color" => "gray", "border-radius" => "10px",
    "overflow-y" => "scroll", "height" => "0px", "transition" => "1s")
    myuploader = ToolipsUploader.fileinput(c,
    "pizza") do cm::ComponentModifier, file::String
        try
            readstr = read(file, String)
            style!(cm, uploaderbox, "height" => "250px")
            set_children!(cm, "uploaderbox", components(tmd("customtmd", readstr)))
        catch
            rm(file)
            errora = a("errora",
            text = "Error! You probably uploaded the wrong type of file, didn't you?")
            style!(errora, "color" => "red")
            style!(cm, uploaderbox, "height" => "20px")
            set_children!(cm, "uploaderbox", components(errora))
        end
    end
    push!(uploadersection, uploader_logo, uploader_vlink, uploader_tmd,
     myuploader, uploaderbox)
    #==
    Defaults
    ==#
    #==
    Main
    ==#
    maindiv = divider("maindiv", align = "center")
    style!(maindiv, "border-radius" => "25px", "border-style" => "solid",
    "border-color" => "lightblue", "margin-top" => "100px",
    "background" => "linear-gradient(#99CCED, #C4FEFF)")
    push!(maindiv, overview, markdownsection, uploadersection)
    write!(c, maindiv)
end

fourofour = route("404") do c
    write!(c, p("404message", text = "404, not found!"))
end

"""
start(IP::String, PORT::Integer, extensions::Vector{Any}) -> ::Toolips.WebServer
--------------------
The start function comprises routes into a Vector{Route} and then constructs
    a ServerTemplate before starting and returning the WebServer.
"""
function start(IP::String = "127.0.0.1", PORT::Integer = 8000,
    extensions::Vector = [Logger()])
    rs = routes(route("/", home), fourofour)
    server = ServerTemplate(IP, PORT, rs, extensions = extensions)
    server.start()
end

end # - module
