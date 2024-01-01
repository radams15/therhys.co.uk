class BlogModel < ApplicationRecord
  @@post_location = Dir.pwd+"/posts"

  def posts tags=nil
    STDERR.puts @@post_location
    posts = Dir.entries(@@post_location)
      .select{ |f| f.match(/.*\.(?:md|html)/)}

    posts = posts.each.map{ |fname|
      content=''
      in_header = true
      conf = {}
      File.readlines(File.join(@@post_location, fname), chomp: true).each do |line|
        if in_header
          if line.match(/----*/)
            in_header = false
            next
          else
            if line =~ /(.*?):\s*(.*)/
              conf[$1] = $2;
            end
          end
        else
          content += line
        end
      end

      conf['Tags'] = conf['Tags']&.split(/,\s*/)

      {
        'file' => fname,
        'conf' => conf,
        'content' => content
      }
    }

    posts.filter{ |post|
      if tags != nil
        post['conf']['tags']&.each do |tag|
          if tags.include? tags
            return 1
          end
        end
        return 0
      else
        1
      end
    }
  end
end
