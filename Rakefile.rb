require 'rake/clean'

MAIN = 'master-thesis-pytropos' # name of the pdf
PDF = "#{MAIN}.pdf"
TEX = "#{MAIN}.tex"
AUX = "#{MAIN}.aux"

CLEAN.include(['aux', 'bbl', 'bcf', 'blg', 'log', 'out', 'run.xml', 'tdo', 'toc'].collect {|ext| "#{MAIN}.#{ext}"})
CLOBBER.include PDF

task :default => [:compile]

file AUX => ['bibliography.bib'] do
  sh "xelatex '#{TEX}'"
  sh "biber '#{MAIN}'"
end

file PDF => ['MastersDoctoralThesis.cls', AUX, TEX] do
  sh "xelatex '#{TEX}'"
  sh "xelatex '#{TEX}'"
  puts "DONE"
end

desc "Creates pdf file"
task :compile => [PDF]

#desc "runs `xelatex` once"
#task :once => [PDF]

desc "Runs 'compile' every second, if no change have been made nothing is done"
task :cicle do
  all_tasks = [PDF].map {|t| Rake::Task[t]}
  loop do
    begin
      all_tasks.each {|t| t.reenable}
      all_tasks.each {|t| t.invoke}
    rescue => e
      puts "Error: #{e}, sleeping for 15 seconds."
      Kernel.sleep 15
    end
    Kernel.sleep 1
  end
end
