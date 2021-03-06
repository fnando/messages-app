require "securerandom"

class GoogleAnalytics
  def self.page_view(path, request, cid)
    host = request.host
    ua = request.user_agent
    referrer = request.referer
    remote_ip = request.ip

    Job.perform_async(cid, host, path, ua, referrer, remote_ip)
  end

  class Job
    include SuckerPunch::Job

    def perform(cid, host, path, ua, referrer, remote_ip)
      params = {
        v: ENV["GOOGLE_ANALYTICS_VERSION"],
        tid: ENV["GOOGLE_ANALYTICS_CODE"],
        cid: cid,
        t: "pageview",
        dh: host,
        dp: path,
        ua: ua,
        dr: referrer,
        uip: remote_ip,
      }

      Aitch.post("https://ssl.google-analytics.com/collect", params)
    end
  end
end
