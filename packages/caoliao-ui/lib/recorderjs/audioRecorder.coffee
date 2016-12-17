@AudioRecorder = new class
	start: (cb) ->
		if Meteor.isClient and (navigator.getUserMedia? or navigator.webkitGetUserMedia?) 
			window.AudioContext = window.AudioContext or window.webkitAudioContext
			navigator.getUserMedia = navigator.getUserMedia or navigator.webkitGetUserMedia
			window.URL = window.URL or window.webkitURL

			if !@audio_context?
				@audio_context = new AudioContext

			ok = (stream) =>
				@startUserMedia(stream)
				cb?.call(@)

			if not navigator.getUserMedia?
				return cb false

			navigator.getUserMedia {audio: true}, ok, (e) ->
				console.log('No live audio input: ' + e)
				toastr.error e.message
			console.log("Printed in browsers and mobile apps");

		if Meteor.isCordova or navigator.device?
			captureSuccess = (mediaFiles) ->
				for meidaFile in mediaFiles
					path = meidaFile.fullPath;
					navigator.notification.alert(meidaFile);
					navigator.notification.alert(path) 

			captureError = (error) ->
				navigator.notification.alert('Error code: ' + error.code, null, 'Capture Error');

			navigator.device.capture.captureAudio(captureSuccess, captureError);
			console.log("Printed only in mobile Cordova apps");
		

	startUserMedia: (stream) ->
		@stream = stream
		input = @audio_context.createMediaStreamSource(stream)
		@recorder = new Recorder(input, {workerPath: '/recorderWorker.js'})
		@recorder.record()

	stop: (cb) ->
		@recorder.stop()

		if cb?
			@getBlob cb

		@stream.getAudioTracks()[0].stop()

		@recorder.clear()

		# delete @audio_context
		delete @recorder
		delete @stream
		console.log @audio_context

	getBlob: (cb) ->
		@recorder.exportWAV cb