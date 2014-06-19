module Cielo24
  module Jobs

    # Public: Creates a new job.
    #
    # job_name - A human-readable name for the job to be created.
    # language - An RFC 5646 Language tag indicating native job language. Defaults to ‘en’.
    #
    # Returns a job id for the newly created job.
    def create_job(job_name, language = "en")
      data = get_json("/api/job/new", {job_name: job_name, language: language})

      return data["JobId"]
    end

    # Public: Attaches media to a job.
    #
    # job_id - The id of a job to attach media to.
    # media_url - The URL of the media file to attach to the job.
    #
    # Returns the task id for the media.
    def add_media(job_id, media_url)
      data = get_json("/api/job/add_media", {job_id: job_id, media_url: media_url})

      data["TaskId"]
    end

    # Public: Requests that a transcription be performed.
    # 
    # job_id - The id of a job to attach media to.
    # fidelity - Should be one of MECHANICAL, PREMIUM, or PROFESSIONAL. Default: PROFESSIONAL
    # priority - Should be one of ECONOMY, STANDARD, or PRIORITY. Default: STANDARD
    # options - Additional optional parameters for perform the transcription. See the Cielo24 documentation
    #           for the full list.
    # 
    # Returns the task id for the transcription.
    def perform_transcription(job_id, fidelity = "PROFESSIONAL", priority = "STANDARD", options = {})
      options = options.merge(job_id: job_id, transcription_fidelity: fidelity, priority: priority)
      data = get_json("/api/job/perform_transcription", options)

      data["TaskId"]
    end

    # Public: Requests info about a particular job.
    #
    # job_id - The job to get info about.
    #
    # Returns the job info as JSON
    def job_info(job_id)
      get_json("/api/job/info", {job_id: job_id})
    end

    # Public: Requests the status info for a particular task.
    #
    # task_id - The task to get info about.
    #
    # Returns the task info as JSON
    def task_status(task_id)
      get_json("/api/job/task_status", {task_id: task_id})
    end

    # Public: Returns whether or not a task has completed.
    #
    # task_id - The task to check status for.
    #
    # Returns true if the task is complete, false otherwise.
    def task_complete?(task_id)
      task_status(task_id)["TaskStatus"] == "COMPLETE"
    end

    # Public: Gets the caption results from a job.
    #
    # job_id - The id of the job we're pulling captions for.
    # caption_format - THe format for the captions. SRT, SBV, DFXP, or QT. Defaults to SRT.
    # options - Additional optional parameters for requesting captions. See the Cielo24 documentation
    #           for the list of optional parameters.
    #
    # Returns the caption data as text.
    def get_caption(job_id, caption_format = "SRT", options = {})
      get("/api/job/get_caption", options.merge(caption_format: caption_format, job_id: job_id))
    end

    # Public: Gets the transcript results from a job.
    #
    # job_id - The id of the job we're retrieving a transcription for.
    # options - Optional parameters for requesting transcripts. See the Cielo24 documentation
    #           for the full list of parameters.
    #
    # Returns the transcript data as text.
    def get_transcript(job_id, options = {})
      get("/api/job/get_transcript", options.merge(job_id: job_id))
    end
  end
end