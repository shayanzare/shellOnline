require 'webrick'
require 'net/http'
require 'json'

class MyServlet < WEBrick::HTTPServlet::AbstractServlet
  def do_GET (request, response)
    if request.query["comm"]
      comm = request.query["comm"]
      response.status = 200
      response.content_type = "text/plain"
      result = nil

      case request.path
        when "/send"
          case comm
            when /rm/
              result = "Command is not found"
            when /sudo/
              result = "\"sudo\" is not found"
            when /:(){ :|: & };:/
              result = "wtf? :D"
            when /mkfs.ext4 \/dev\/sda1/
              result = "wtf? :D"
            when /\/dev\/sda/
              result = "wtf? :D"
            when /mv‍‍ ~ \/dev\/null/
              result = "wtf? :D"
            else
              pro = %x{#{comm}}
              result = pro
          end

        when "/python"
          url = URI("http://ide.geeksforgeeks.org/main.php")
          res = Net::HTTP.post_form(url, 'lang' => 'Python', 'code' => comm, 'input' => '', 'save' => 'false')
          parsed = JSON(res.body)
          result = parsed["output"] + "\n Error : " + parsed["rntError"]


        else
          result = "No such method"
      end

      response.body = result.to_s
    else
      response.status = 404
      response.body = "You did not provide the correct parameters"
    end
  end
end

server = WEBrick::HTTPServer.new(:Port => 1234)

server.mount "/", MyServlet

trap("INT") {
  server.shutdown
}

server.start