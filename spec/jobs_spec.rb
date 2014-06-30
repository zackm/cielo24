require "spec_helper"

describe "Cielo24::Jobs" do

  let(:client) { Cielo24::Client.new }

  let(:job_id) do
    stub_get_json("/api/job/new", {"JobId" => "JOB123"})
    client.create_job("Test Job")
  end

  let(:job_with_media_id) do
    stub_get_json("/api/job/add_media", {"TaskId" => "TASK123"})
    client.add_media(job_id, "http://test.com/media.mp4")

    job_id
  end

  let(:transcribed_job_id) do
    stub_get_json("/api/job/perform_transcription", { "TaskId" => "TASK123"})
    client.perform_transcription(job_with_media_id)

    # it unfortunately takes a second to get a successful caption back from the
    # sandbox
    sleep(3) if test_sandbox?
  end

  describe "#create_job" do
    it "returns the job id for the newly created job" do
      stub_get_json("/api/job/new", {"JobId" => "JOB123"})
      expect(client.create_job("Some New Job")).to_not be_nil
    end
  end

  describe "#add_media" do
    it "returns the task id for the media that was added" do
      stub_get_json("/api/job/add_media", {"TaskId" => "TASK123"})
      expect(client.add_media(job_id, "http://test.com/test_media.mp4")).to_not be_nil
    end
  end

  describe "#perform_transcription" do
    it "returns the task id for the transcription" do
      stub_get_json("/api/job/perform_transcription", {"TaskId" => "TASK123"})
      expect(client.perform_transcription(job_with_media_id)).to_not be_nil
    end
  end

  describe "#task_complete?" do
    it "returns true if the task has completed" do
      pending("CANNOT GUARANTEE COMPLETED JOB IN SANDBOX") if test_sandbox?

      stub_get_json("/api/job/task_status", {"TaskStatus" => "COMPLETE"})
      expect(client.task_complete?("TASK123")).to be_true
    end

    it "returns false if the task hasn't completed" do
      pending("CANNOT GUARANTEE INCOMPLETE JOB IN SANDBOX") if test_sandbox?

      stub_get_json("/api/job/task_status", {"TaskStatus" => "INCOMPLETE"})
      expect(client.task_complete?("TASK123")).to be_false
    end
  end

  describe "#job_info" do
    it "returns job info" do
      stub_get_json("/api/job/info", {"JobId" => "JOB123", "JobName" => "A Test Job"})
      expect(client.job_info(job_id)).to_not be_nil
    end
  end

  describe "#task_status" do
    it "returns the task status" do
      stub_get_json("/api/job/task_status", {"TaskId" => "TASK123", "TaskType" => "JOB_PERFORM_TRANSCRIPT"})
      expect(client.task_status("TASK123")).to_not be_nil
    end
  end

  describe "#get_caption" do
    it "returns the captions" do
      pending("SANDBOX DOESN'T ALWAYS RETURN CAPTIONS CORRECTLY") if test_sandbox?
      
      stub_get("/api/job/get_caption", "SOME CAPTION DATA")
      expect(client.get_caption(transcribed_job_id)).to_not be_nil
    end
  end

  describe "#get_transcript" do
    it "returns the transcripts" do
      pending("SANDBOX DOESN'T ALWAYS RETURN TRANSCRIPTS CORRECTLY") if test_sandbox?

      stub_get("/api/job/get_transcript", "This is some transcript data.")
      expect(client.get_transcript(transcribed_job_id)).to_not be_nil
    end
  end
end