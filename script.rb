require "rubygems"

require "cgi"
require "fastercsv"

class VideoDownloader
  @@watch_url = "http://www.youtube.com/watch?v="

  def initialize(url)
    @url = url
  end

  def video_id
    CGI.parse(@url.split('?')[1])['v'][0]
  end
  
  def download(file)
    download = @@watch_url + video_id
    cmd = 'youtube-dl -o ' + file + ' ' + download
    puts cmd
    system(cmd)
  end
end

class CSVDownloader
  def initialize(csvFile)
    @csvFile = csvFile
    puts "File name " + @csvFile
  end
  
  def fixName(name)
    return name.tr(' ', '_') + ".avi"
  end
  
  def download
    FasterCSV.foreach(@csvFile) do |row|
      videoUrl = row[0]
      downloader = VideoDownloader.new(videoUrl)
      fileName = fixName(row[1])
      downloader.download(fileName)
    end
  end
  
end

fileName = ARGV[0]
downloader = CSVDownloader.new(fileName)
downloader.download




