namespace :send_reports do
  desc "Send all reports in the system"
  task :send_all => :environment do
    #SendAdminReportJob.perform_later()
    puts "Sending Reports"
  end
end
