class HelloJob < ApplicationJob
  queue_as :default

  def perform(*args)
    puts "\n\n\n\n\n-------------------\nHELLO WORLD!\n+++++++++++++++\n\n\n"
    # Do something later
  end
end
