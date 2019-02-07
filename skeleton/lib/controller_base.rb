require 'active_support'
require 'active_support/core_ext'
require 'erb'
require_relative './session'
require 'active_support/inflector'

class ControllerBase
  attr_reader :req, :res, :params

  # Setup the controller
  def initialize(req, res)
    @req, @res = req, res 

  end

  # Helper method to alias @already_built_response
  def already_built_response?
    !!@already_built_response
  end

  # Set the response status code and header
  def redirect_to(url)
    raise "Double Render Error" if @already_built_response
    @res.status = 302
    @res['Location'] = url 
    @session.store_session(@res)
    @already_built_response = true 

  end

  # Populate the response with content.
  # Set the response's content type to the given type.
  # Raise an error if the developer tries to double render.
  def render_content(content, content_type='text/html')
    raise "Double Render Error" if @already_built_response
    @res.write(content)
    @res['Content-Type'] = content_type
    @session.store_session(@res)
    @already_built_response = true 
  end

  # use ERB and binding to evaluate templates
  # pass the rendered html to render_content
  def render(template_name)
    raise "Double Render Error" if @already_built_response

    path = File.dirname(File.dirname(__FILE__))
    controller_name = self.class.to_s

    file_path = File.join(path,"views/#{controller_name.underscore}/#{template_name}.html.erb")

    content = File.read(file_path)
    
    erb_code = ERB.new(content).result(binding)
    render_content(erb_code)

    

    @already_built_response = true
  end

  # method exposing a `Session` object
  def session
    @session ||= Session.new(@req)
  end

  # use this with the router to call action_name (:index, :show, :create...)
  def invoke_action(name)


  end
end

