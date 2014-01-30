module Cielo24
  module Jobs

    # Public: Creates a new job.
    #
    # job_name - A human-readable name for the job to be created.
    # language - An RFC 5646 Language tag indicating native job language. Defaults to ‘en’.
    #
    # Returns a job id for the newly created job.
    def create_job(job_name, language = "en")
      data = get("/api/job/new", {job_name: job_name, language: language})

      return data["JobId"]
    end

    # Public: Attaches media to a job.
    #
    # job_id - The id of a job to attach media to.
    # media_url - The URL of the media file to attach to the job.
    #
    # Returns the task id for the media.
    def add_media(job_id, media_url)
      data = get("/api/job/add_media", {job_id: job_id, media_url: media_url})

      data["TaskId"]
    end

    # Public: Requests that a transcription be performed.
    # 
    # job_id - The id of a job to attach media to.
    # fidelity - Should be one of MECHANICAL, PREMIUM, or PROFESSIONAL. Default: PROFESSIONAL
    # priority - Should be one of ECONOMY, STANDARD, or PRIORITY. Default: STANDARD
    # 
    # Returns the task id for the transcription.
    def perform_transcription(job_id, fidelity = "PROFESSIONAL", priority = "STANDARD")
      data = get("/api/job/perform_transcription", 
          {job_id: job_id, transcription_fidelity: fidelity, priority: priority})

      data["TaskId"]
    end
  end
end