/**
 * This JavaScript file is created
 * to initiate the CometD library,
 * register CometD listeners, perform
 * Channel Subscription and various
 * other actions.
 * 
 * @author      Shruti Sridharan
 * @since       27.11.17
 * @revisions   N/A
 **/
var AnnouncementsApp = {
    constants : {},
    
    actions : {
        /**
         * Intialize the CometD library
         * with the URL and the Session
         * ID for authentication.
         **/
        initCometD : function() {
            $.cometd.init(
                {
                    url                     : AnnouncementsApp.constants.COMETD_URL,
                    requestHeaders          : {
                        Authorization       : "Bearer " + AnnouncementsApp.constants.SESSION_ID
                    }
                }
            );
        },
        /**
         * Register to all the CometD Events
         * such as Handshake, Connect and
         * Disconnect.
         */
        registerCometDListeners : function() {
            /**
             * Do the Subscription only after
             * the "Handshake" was successful.
             */
            $.cometd.addListener(
                "/meta/handshake",
                function( message ) {
                    if( message.successful ) {
                        console.info( new Date() + " : CometD Handshake Completed." );

                        AnnouncementsApp.actions.subscribeToChannel();
                    }
                    else {
                        /**
                         * If the Handshake failed we
                         * need to restart the init
                         * process.
                         */
                        console.info( new Date() + " : CometD Handshake Failed." );

                        AnnouncementsApp.actions.initCometD();
                    }
                }
            );
            
            /**
             * If it's getting disconnected
             * we need to restart the init
             * process.
             */
            $.cometd.addListener(
                "/meta/connect",
                function( message ) {
                    if( $.cometd.isDisconnected() ) {
                        console.info( new Date() + " : CometD Disconnected." );

                        AnnouncementsApp.actions.initCometD();
                    }
                }
            );

            /**
             * Restart the init process if
             * the CometD has disconnected.
             */
            $.cometd.addListener(
                "/meta/disconnect",
                function( message ) {
                    console.info( new Date() + " : CometD Disconnected." );

                    AnnouncementsApp.actions.initCometD();
                }
            );
        },
        /**
         * Subscribe to the Push Topic
         * aka the Channel.
         **/
        subscribeToChannel : function() {
         //Compile the Handlebars Template
            var source      = $( "[id='announcement-template']" ).html();
            var template    = Handlebars.compile( source );
            
            $.cometd.subscribe(
                AnnouncementsApp.constants.CHANNEL_URL,
                function( message ) {
                    $( "#divNoAnnouncements" ).hide();
                    
                 //Fill the Handlebars Merge Fields
                    var html = template( message.data.sobject );
                    $( "#divAnnouncements" ).append( html );
					debugger;
                    //Display a Desktop Notification
                    /*Push.create(
                        message.data.sobject.Name, 
                        {
                            body: message.data.sobject.Details__c,
                            icon: AnnouncementsApp.constants.ICON_PATH,
                            timeout: 4000,
                            onClick: function () {
                                window.focus();
                                this.close();
                            }
                        }
                    );*/
					/*if (window.Push!='undefined') {
					Push.create(
                        message.data.sobject.Name, 
                        {
                            body: message.data.sobject.Details__c,
                            icon: AnnouncementsApp.constants.ICON_PATH,
                            timeout: 4000,
                            onClick: function () {
                                window.focus();
                                this.close();
                            }
                        }
                    );
					}
					else {*/
					AnnouncementsApp.actions.ftn_display_notification('divAnnouncements',1,message.data.sobject.Name,message.data.sobject.Name,AnnouncementsApp.constants.ICON_PATH);
						
					
						
						
					//}
                }
            );
        },
		ftn_display_notification : function(elementid,seconds,message,title,icon)
{
	window.setTimeout(function () 
	{
		instance = new Notification(
			title, {
				body: message,
				icon: icon
			}
		);
		
		instance.onclick = function () {
			// Something to do
			//document.getElementById(elementid).innerHTML="Clicked";
		};
		instance.onerror = function () {
			alert("Something went wrong.");
		};
		instance.onshow = function () {
			// Something to do
			//document.getElementById(elementid).innerHTML="Shown";
		};
		instance.onclose = function () {
			// Something to do
			//document.getElementById(elementid).innerHTML="Closed";
		};
		
	}, seconds*1000);
	console.log(instance);
},
	ftn_request_permission : function(elementid)
{
	//check browser is supported...
	
	
	var permission = Notification.requestPermission(function (permission) 
	{
		if (permission == "granted") 
		{	
			console.log("Permission Granted");
		}
		if (permission == "default")
		{
			//document.getElementById(elementid).innerHTML="DEFAULT";
		}
		if (permission == "denied")
		{
			console.log("Permission Denied.");
		}
	});	
},
        /**
         * Mark an Announcement as read
         * by removing it from the VF
         * Page as well as creating a
         * record in the Acknowledged
         * Users object to mart the
         * acknowledgment.
         **/
        dismissAnnouncement : function( annId ) {
         //Using VF Remote Objects to perform the CRUD
            var ack = new SObjectModel.Acknowledged_User__c( { Announcement__c : annId } );
            
            ack.create(
                function( err ) {
                    if ( err ) {
                        alert( "Failed to Acknowledge! Error: " + err );
                    }
                    else {
                        $( "#" + annId ).fadeOut();
                    }
                }
            );
        }
    },
    
    eventHandlers : {
        dismissAnnouncement : function( annId ) {
            AnnouncementsApp.actions.dismissAnnouncement( annId );
        }
    },
    
    init : function( config ) {
        AnnouncementsApp.constants = config;
        
        AnnouncementsApp.actions.registerCometDListeners();
        AnnouncementsApp.actions.initCometD();
		AnnouncementsApp.actions.ftn_request_permission('divAnnouncements');
    },
	
};