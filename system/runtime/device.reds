Red/System []

devices: context [
	#define DEVICE_MAX 16
	#define GET_FLAG(r) []
	#define SET_FLAG(r) []
	#define CLR_FLAG(r) []

	;; Red Device Commands:
	#enum device-commands! [
		DC_INIT	;; init device driver resources
		DC_QUIT	;; cleanup device driver resources
		DC_OPEN	;; open device unit (port)
		DC_CLOSE	;; close device unit
		DC_READ	;; read from unit
		DC_WRITE	;; write to unit
		DC_POLL	;; check for activity
		DC_CONNECT	;; connect (in or out)
		DC_QUERY	;; query unit info
		DC_MODIFY	;; set modes (also get modes)
		DC_CREATE	;; create unit target
		DC_DELETE	;; delete unit target
		DC_RENAME
		DC_LOOKUP
		DC_MAX
		DC_CUSTOM: 32	;; start of custom commands
	]

	;; Red Device Flags and Options (bitnums):
	#enum device-flag! [
		;; Status flags:
		DF_INIT	;; Device is initialized
		DF_OPEN	;; Global open (for devs that cannot multi-open)
		;; Options:
		DO_MUST_INIT: 16	;; Do not allow auto init (manual init required)
		DO_AUTO_POLL	;; Poll device, even if no requests (e.g. interrupts)
	]

	;; Red Request Flags (bitnums):
	#enum request-flag! [
		RF_OPEN	;; Port is open
		RF_DONE	;; Request is done (used when extern proc changes it)
		RF_FLUSH	;; Flush WRITE
		; RF_PREWAKE ;; C-callback before awake happens (to update port object)
		RF_PENDING	;; Request is attached to pending list
		RF_ALLOC	;; Request is allocated, not a temp on stack
		RF_WIDE	;; Wide char IO
		RF_ACTIVE	;; Port is active, even no new events yet
	]

	;; Red Device Errors:
	#enum device-error! [
		DE_NONE
		DE_NO_DEVICE	;; command did not provide device
		DE_NO_COMMAND	;; command past end
		DE_NO_INIT	;; device has not been inited
	]


	request!: alias struct! [
		test [integer!]
	]

	;; Device structure:
	
	device!: alias struct! [
		title 			[byte-ptr!]		;; title of device
		version			[integer!]		;; version, revision, release
		date			[integer!]		;; year, month, day, hour
		commands		[byte-ptr!]		;; command dispatch table
		max-command		[integer!]		;; keep commands in bounds
		pending			[request!]		;; pending requests
		flags 			[integer!]		;; state: open, signal
		req-size		[integer!]		;; size of request struct
	]

	;; Request structure: ;; Allowed to be extended by some devices

	device-request!: alias struct! [
		length 			[integer!]		;; size of extended structure

		;; Linkages:
		device 			[integer!]	;; device id (dev table)
		next 			[request!]	;; linked list (pending or done lists)
		port 			[byte-ptr!]	;; link back to port object
		
		handle 			[byte-ptr!]
		socket 			[integer!]
		id 				[integer!]

		;; Command info:
		command 		[integer!]	;; command code
		error 			[integer!]	;; error code
		modes 			[integer!]	;; special modes, types or attributes
		flags 			[integer!]	;; request flags
		state 			[integer!]	;; device process flags
		timeout 		[integer!]	;; request timeout


		data 			[byte-ptr!]	;; data to transfer
		sock 			[byte-ptr!]	;; temp link to related socket

		length 			[integer!]	;; length to transfer
		actual 			[integer!]	;; length actually transferred

		;;; Special fields for IO

		;;File
		path 			[byte-ptr!]	;; OS local string type
		size 			[integer!]	;; File size
		index			[integer!]	;; File index position
		time 			[byte-ptr!]	;; time structure?

		;;Net
		; local-ip		
		; local-port
		; remote-ip
		; remote-port
		; host-info

	]

	;; Red Device Functions

	poll-default: func [] []
	attach-request: func [] []
	detach-request: func [] []
	done-device: func [] [] ;; used by DNS?
	signal-device: func [] []
	os-call-device: func [] []
	os-do-device: func [] []
	os-make-device-request: func [] []
	os-abort-device: func [] []
	os-poll-devices: func [] []
	os-quit-devices: func [] []
	os-wait: func [] []

	;; Red Device Table

	list: declare struct! [
		standard-io 	[device!]
		file 			[device!]
		event 			[device!]
		net 			[device!]
		dns 			[device!]
		clipboard 		[device!]
		serial 			[device!]
	]
]