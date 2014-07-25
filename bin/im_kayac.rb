#
# IM::Kayac
# License: Ruby
# See also: http://im.kayac.com/
# Usage:
#
# im = IM::Kayac.new('to', :id => 'from', :sig => 'sigunature')
# res = im.notify('message') #ret Net::HTTPResponse
# require 'json'
# JSON.parse(res.body).each do |k, v|
#   printf "%s: %s\n", k, v
# end
#
# http://coderepos.org/share/browser/lang/ruby/misc/im/kayac.rb

require 'digest/sha1'
require 'net/http'

module IM
 class Kayac
   HOST = 'im.kayac.com'
   def initialize(to, params={})
     if to.nil?
       raise ArgumentError
     else
       @to = to
     end
     @id  = params[:id]
     @pwd = params[:password]
     @sig = params[:sig]
   end

   def notify(msg)
     if !@sig.nil?
       sig = Digest::SHA1.hexdigest(msg + @sig)
       data = 'message=%s&amp;sig=%s' % [u(msg), sig]
     elsif !@pwd.nil?
       data = 'message=%s&amp;password=%s' % [u(msg), u(@pwd)]
     else
       data = 'message=%s' % [u(msg)]
     end
     data << '&amp;id=%s' % [u(@id)] unless @id.nil?
     header = {
       'Host' => HOST,
       'Content-Type' => 'application/x-www-form-urlencoded',
       'Content-length' => data.size.to_s,
     }

     path = '/api/post/%s' % [@to]
     Net::HTTP.version_1_2
     Net::HTTP.start(HOST, 80) do |http|
       http.post(path, data, header)
     end
   end

   private
   def u(str)
     str.to_s.gsub(/[^a-zA-Z0-9_\-.]/n) do
       '%%%02X' % $&.unpack("C").first
     end
   end

 end
end
