# Cielo24

Cielo24 is a service for creating video captions and transcripts. This library interacts with the Cielo24 API to submit and retrieve captions.

This is currently an incomplete implementation fo the Cielo24 API to solve my personal needs. Feel free to send a pull request if you want to complete more of the API.

## Installation

Add this line to your application's Gemfile:

    gem 'cielo24'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install cielo24

## Usage

### Authentication:

The Cielo24 team recommend password based authentication, so to configure your username and password:

```
Cielo24::Client.configure(username: "user", password: "somepass")
```

You may also authenticate through the Cielo24 sandbox with the following settings (use your own sandbox username and password):

```
Cielo24::Client.configure(username: "username", password: "password", 
    uri: "https://sandbox.cogi.com", verify_mode: OpenSSL::SSL::VERIFY_NONE)
```

### Submitting a video for captioning:

```
client = Cielo24::Client.new
job_id = client.create_job("Test Job")
client.add_media(job_id, "http://test.com/my-media.mp4")
task_id = client.perform_transcription(job_id)
```

Captioning defaults to professional fidelity and standard priority.

### Checking if captions are complete:

```
client = Cielo24::Client.new
client.task_complete?(task_id)
```

### Downloading captions

```
client = Cielo24::Client.new
data = client.get_caption(job_id)
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request