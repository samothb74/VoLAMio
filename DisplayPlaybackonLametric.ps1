$PlaybackFile = "PATH TO THE JSON FOLDER"

#Api Settings
$LametricIP="LAMETRIC IP"
$VolumioIP="VOLUMIO IP"

$ApiKey="ENTER YOUR API KEY HERE"
$URI= "http://" + $VolumioIP +"/api/v1/getState"
#Code
$resultjson=@"
{
  "$schema": "http://json-schema.org/draft-04/schema#",
  "type": "object",
  "properties": {
    "status": {
      "type": "string"
    },
    "title": {
      "type": "string"
    },
    "artist": {
      "type": "string"
    },
    "album": {
      "type": "string"
    },
    "albumart": {
      "type": "string"
    },
    "uri": {
      "type": "string"
    },
    "trackType": {
      "type": "string"
    },
    "seek": {
      "type": "integer"
    },
    "duration": {
      "type": "integer"
    },
    "samplerate": {
      "type": "string"
    },
    "bitdepth": {
      "type": "string"
    },
    "channels": {
      "type": "integer"
    },
    "consume": {
      "type": "boolean"
    },
    "volume": {
      "type": "integer"
    },
    "dbVolume": {
      "type": "null"
    },
    "mute": {
      "type": "boolean"
    },
    "disableVolumeControl": {
      "type": "boolean"
    },
    "stream": {
      "type": "boolean"
    },
    "updatedb": {
      "type": "boolean"
    },
    "volatile": {
      "type": "boolean"
    },
    "disableUiControls": {
      "type": "boolean"
    },
    "service": {
      "type": "string"
    }
  },
  "required": [
    "status",
    "title",
    "artist",
    "album",
    "albumart",
    "uri",
    "trackType",
    "seek",
    "duration",
    "samplerate",
    "bitdepth",
    "channels",
    "consume",
    "volume",
    "dbVolume",
    "mute",
    "disableVolumeControl",
    "stream",
    "updatedb",
    "volatile",
    "disableUiControls",
    "service"
  ]
}
"@

Invoke-WebRequest -Uri $URI -ContentType "application/json" -Headers $header -UseBasicParsing -outfile $PlaybackFile

$resultjson = Get-Content -Raw -Path $PlaybackFile | ConvertFrom-Json



$Text = $resultjson.artist + "-" + $resultjson.title

$json=@"
{
   "priority":"$Priority",
   "model": {
        "frames": [
            {
               "icon":5865,
               "text":"$Text"
   
            }
        ]
    }
   
}
"@

$base64AuthInfo = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("dev:$ApiKey")))

$header = @{
    Authorization=("Basic {0}" -f $base64AuthInfo)
}




    if ( ((Get-Content $PlaybackFile | Measure -Character).Characters) -gt 58 ) {
            Invoke-RestMethod -Method POST -Uri ("http://"+$LametricIP+":8080/api/v2/device/notifications") -ContentType "application/json" -Headers $header -UseBasicParsing -Body $json
            }
else {

    }
