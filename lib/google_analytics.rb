require "securerandom"

class GoogleAnalytics
  def self.page_view(path, request)
    host = request.host
    ua = request.user_agent
    referrer = request.referer
    remote_ip = request.ip

    Job.new.async.perform(host, path, ua, referrer, remote_ip)
  end

  class Job
    include SuckerPunch::Job

    def perform(host, path, ua, referrer, remote_ip)
      params = {
        v: ENV["GOOGLE_ANALYTICS_VERSION"],
        tid: ENV["GOOGLE_ANALYTICS_CODE"],
        cid: SecureRandom.hex(20),
        t: "pageview",
        dh: host,
        dp: path,
        ua: ua,
        dr: referrer,
        uip: remote_ip,
      }

      Aitch.post("http://www.google-analytics.com/collect", params)
    end
  end
end
