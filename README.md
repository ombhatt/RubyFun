RubyFun
=======
## Test One

Using your favorite REST client library (e.g. https://github.com/technoweenie/faraday) write a Zendesk API client that:

1. Creates a user
2. Creates a ticket with that user as requester
3. Marks that ticket as solved

You can create a Zendesk account by signing up at http://www.zendesk.com/

There is more information about the Zendesk API available here: http://www.zendesk.com/api/ and the documentation specifically for the REST interface: http://www.zendesk.com/api/rest-introduction

## Test Two

Write a Ruby class that opens a CSS file, and does a simple compression of it by removing all the blank lines, and lines that are only comments.

````css
css_compressor = CSSCompressor.new(filename)
css_compressor.compress_to(destination_filename)
````

Given file contents that look like this:

````css
/* reset a few things */
body {
  margin: 0;
  padding: 0;
}

/* for the main content div */
#content {
  margin: 10px
}
````

It should compress down to the following

````css
body {
  margin: 0;
  padding: 0;
}
#content {
  margin: 10px
}
````

## Test Three

Write a Ruby class that implements a letter-based grading system (A+, A, A-, ...).  The class should be able to naturally sort by the value of grade (i.e., A+ > A > A-).  The class should be constructed with a string-value for the grade.

````ruby
a_plus = Grade.new("A+")
a      = Grade.new("A")
a_plus > a       # should return true
[a_plus, a].sort # should return [a, a_plus]
````

## Test Four

Refactoring.Your task is to take the following code and make it easy to read and easy to extend. You'll want to fix as many syntactic problems as possible while altering the final output as little as possible. The code below is executable.

````ruby
class Blog < Object
  def initialize(options = {})
    @header = options[:header]
    @footer = options[:bottom]
    @renderer = options[:renderer]
    @posts = options[:posts]

  end

  class_eval do
    def all_posts
      @posts
    end
  end

  def htmlDiv(content)
    return "<div>" + content + "</div>"
  end

  def htmlH1(content)
    return ("<h1>" + content + "</h1>")
  end


  def render
    output = [htmlDiv(htmlH1 @header)]
     for p in all_posts.sort{|a,b| a[:created_at].to_i <=> b[:created_at].to_i }
      self.current_post = p
      output = output + render_post(output)
      output = output + render_comments()
    end
    output.push(htmlDiv(@footer))
  end


  def current_post=(post)
    @current_post = post
  end


  def render_post(output)
    begin
      [htmlDiv(@renderer.call(@current_post))]
    rescue
      []
    end
  end

  def render_comments
    [*@current_post[:comments]].each{|c| htmlDiv(c)}
  end

end

require 'date'
posts = [
  { :title => "I like Zendesk", :comments => "Dogs are awesome", :created_at => Time.now },
  { :title => "I like Bananas", :comments => ["Typos are awesome"], :created_at => Time.now },
  { :title => nil, :comments => ["wibbles are wobble", "yay"], :created_at => Time.now }
]

blog = Blog.new(:posts => posts, :header => "my blog", :bottom => "Copyright Wobble (2012)", :renderer => Proc.new{|post| "<p>#{post[:title].upcase}</p>" })

puts blog.render
````
