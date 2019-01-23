require "crinja"
require "../../fifteenfortyfive/constants"

module Template
  extend self

  TEMPLATE_DIR = File.join(__DIR__, "..", "templates")
  ENGINE = Crinja.new(loader: Crinja::Loader::FileSystemLoader.new(TEMPLATE_DIR))

  def render(conn : HTTP::Server::Context, template, locals={} of String => Crinja::Value)
    locals = locals.merge({
      "conn" => conn_to_h(conn)
    })
    template = ENGINE.get_template(template)
    conn.response.puts(template.render(locals))
  end

  private def conn_to_h(conn)
    {
      "user" => conn.current_user?,
      "constants" => Constants.template_constants
    }
  end
end

require "./template/**"
