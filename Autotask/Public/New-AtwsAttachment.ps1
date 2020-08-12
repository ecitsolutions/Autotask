#Requires -Version 4.0

<#

.COPYRIGHT
Copyright (c) ECIT Solutions AS. All rights reserved. Licensed under the MIT license.
See https://github.com/ecitsolutions/Autotask/blob/master/LICENSE.md for license information.

#>
Function New-AtwsAttachment {


    <#
      .SYNOPSIS
      This function creates a new attachment through the Autotask Web Services API.
      .DESCRIPTION
      This function creates a new attachment connected to either an Account, an Opportunity,
      a Project or a Ticket. The attachment can be passed through the pipeline or provided as
      en URL or a file or folder path.
      .INPUTS
      Nothing
      .OUTPUTS
      Autotask attachments
      .EXAMPLE
      New-AtwsAttachment -TicketId 0 -Path C:\Document.docx
      Uploads C:\Document.docx as an attachment to the Ticket with id 0 and sets the attachment title to 'Document.docx'.
      .EXAMPLE
      New-AtwsAttachment -TicketId 0 -Path C:\Document.docx  -Title 'A title'
      Uploads C:\Document.docx as an attachment to the Ticket with id 0 and sets the attachment title to 'A title'.
      .EXAMPLE
      New-AtwsAttachment -TicketId 0 -Path C:\Document.docx -FileLink
      Adds an file link attachment to the Ticket with id 0, title 'Document.docx' and C:\Document.docx as full path.
      .EXAMPLE
      $Attachment = Get-AtwsAttachment -TicketID 0 | Select-Object -First 1
      New-AtwsAttachment -Data $Attachment.Data -TicketId 1 -Title $Attachment.Info.Title -Extension $([IO.Path]::GetExtension($Attachment.Info.FullPath))
      Gets the first attachment from Ticket with id 0 and attaches it to Ticket with id 1
      .NOTE
      Strongly related to Get-AtwsAttachmentInfo
  #>

    [CmdLetBinding(SupportsShouldProcess = $true, DefaultParameterSetName = 'Ticket', ConfirmImpact = 'None')]
    Param
    (

        # An object as a byte array that will be attached to an Autotask object
        [Parameter(
            Mandatory = $true,
            ParameterSetName = 'Account_as_byte'
        )]
        [Parameter(
            Mandatory = $true,
            ParameterSetName = 'Opportunity_as_byte'
        )]
        [Parameter(
            Mandatory = $true,
            ParameterSetName = 'Project_as_byte'
        )]
        [Parameter(
            Mandatory = $true,
            ParameterSetName = 'Ticket_as_byte'
        )]
        [ValidateNotNullOrEmpty()]
        [Byte[]]
        $Data,

        # An object as a byte array that will be attached to an Autotask object
        [Parameter(
            Mandatory = $true,
            ParameterSetName = 'Account_as_byte'
        )]
        [Parameter(
            Mandatory = $true,
            ParameterSetName = 'Opportunity_as_byte'
        )]
        [Parameter(
            Mandatory = $true,
            ParameterSetName = 'Project_as_byte'
        )]
        [Parameter(
            Mandatory = $true,
            ParameterSetName = 'Ticket_as_byte'
        )]
        [ValidateNotNullOrEmpty()]
        [ValidatePattern('^\.?\w+$')]
        [string]
        $Extension,

        # A is required for Data
        [Parameter(
            Mandatory = $true,
            ParameterSetName = 'Account_as_byte'
        )]
        [Parameter(
            Mandatory = $true,
            ParameterSetName = 'Opportunity_as_byte'
        )]
        [Parameter(
            Mandatory = $true,
            ParameterSetName = 'Project_as_byte'
        )]
        [Parameter(
            Mandatory = $true,
            ParameterSetName = 'Ticket_as_byte'
        )]
        [Parameter(
            ParameterSetName = 'Account'
        )]
        [Parameter(
            ParameterSetName = 'Opportunity'
        )]
        [Parameter(
            ParameterSetName = 'Project'
        )]
        [Parameter(
            ParameterSetName = 'Ticket'
        )]
        [Parameter(
            ParameterSetName = 'Account_as_url'
        )]
        [Parameter(
            ParameterSetName = 'Opportunity_as_url'
        )]
        [Parameter(
            ParameterSetName = 'Project_as_url'
        )]
        [Parameter(
            ParameterSetName = 'Ticket_as_url'
        )]
        [ValidateNotNullOrEmpty()]
        [string]
        $Title,

        # A file path that will be attached to an Autotask object
        [Parameter(
            Mandatory = $true,
            ParameterSetName = 'Account'
        )]
        [Parameter(
            Mandatory = $true,
            ParameterSetName = 'Opportunity'
        )]
        [Parameter(
            Mandatory = $true,
            ParameterSetName = 'Project'
        )]
        [Parameter(
            Mandatory = $true,
            ParameterSetName = 'Ticket'
        )]
        [ValidateNotNullOrEmpty()]
        [ValidateScript( {
                if ( -Not ($_ | Test-Path) ) {
                    throw "File or folder does not exist"
                }
                return $true
            })]
        [IO.FileInfo]
        $Path,

        # URL to attach
        [Parameter(
            Mandatory = $true,
            ParameterSetName = 'Account_as_url'
        )]
        [Parameter(
            Mandatory = $true,
            ParameterSetName = 'Opportunity_as_url'
        )]
        [Parameter(
            Mandatory = $true,
            ParameterSetName = 'Project_as_url'
        )]
        [Parameter(
            Mandatory = $true,
            ParameterSetName = 'Ticket_as_url'
        )]
        [URI]
        $URI,

        # Attach as a file link, not an attachment
        [Parameter(
            ParameterSetName = 'Account_as_url'
        )]
        [Parameter(
            ParameterSetName = 'Opportunity_as_url'
        )]
        [Parameter(
            ParameterSetName = 'Project_as_url'
        )]
        [Parameter(
            ParameterSetName = 'Ticket_as_url'
        )]
        [Alias('Link')]
        [switch]
        $FileLink,

        # Attach as a folder link, not an attachment
        [Parameter(
            ParameterSetName = 'Account_as_url'
        )]
        [Parameter(
            ParameterSetName = 'Opportunity_as_url'
        )]
        [Parameter(
            ParameterSetName = 'Project_as_url'
        )]
        [Parameter(
            ParameterSetName = 'Ticket_as_url'
        )]
        [Alias('Folder')]
        [switch]
        $FolderLink,

        # Account ID
        [Parameter(
            Mandatory = $true,
            ParameterSetName = 'Account'
        )]
        [Parameter(
            Mandatory = $true,
            ParameterSetName = 'Account_as_byte'
        )]
        [Parameter(
            Mandatory = $true,
            ParameterSetName = 'Account_as_url'
        )]
        [ValidateScript( {
                if ( -Not (Get-AtwsAccount -id $_) ) {
                    throw "Account does not exist"
                }
                return $true
            })]
        [long]
        $AccountID,

        # Opportunity ID
        [Parameter(
            Mandatory = $true,
            ParameterSetName = 'Opportunity'
        )]
        [Parameter(
            Mandatory = $true,
            ParameterSetName = 'Opportunity_as_byte'
        )]
        [Parameter(
            Mandatory = $true,
            ParameterSetName = 'Opportunity_as_url'
        )]
        [ValidateScript( {
                if ( -Not (Get-AtwsOpportunity -id $_) ) {
                    throw "Opportunity does not exist"
                }
                return $true
            })]
        [long]
        $OpportunityID,

        # Project ID
        [Parameter(
            Mandatory = $true,
            ParameterSetName = 'Project'
        )]
        [Parameter(
            Mandatory = $true,
            ParameterSetName = 'Project_as_byte'
        )]
        [Parameter(
            Mandatory = $true,
            ParameterSetName = 'Project_as_url'
        )]
        [ValidateScript( {
                if ( -Not (Get-AtwsProject -id $_) ) {
                    throw "Project does not exist"
                }
                return $true
            })]
        [long]
        $ProjectID,

        # Ticket ID
        [Parameter(
            Mandatory = $true,
            ParameterSetName = 'Ticket'
        )]
        [Parameter(
            Mandatory = $true,
            ParameterSetName = 'Ticket_as_byte'
        )]
        [Parameter(
            Mandatory = $true,
            ParameterSetName = 'Ticket_as_url'
        )]
        [ValidateScript( {
                if ( -Not (Get-AtwsTicket -id $_) ) {
                    throw "Ticket does not exist"
                }
                return $true
            })]
        [long]
        $TicketID,

        [ValidateSet('All Autotask Users', 'Internal Users Only')]
        [string]
        $Publish = 'All Autotask Users'

    )

    begin {

        # Enable modern -Debug behavior
        if ($PSCmdlet.MyInvocation.BoundParameters['Debug'].IsPresent) { $DebugPreference = 'Continue' }

        Write-Debug ('{0}: Begin of function' -F $MyInvocation.MyCommand.Name)

        # Dynamic field info
        $fields = Get-AtwsFieldInfo -Entity AttachmentInfo

        $Picklists = $fields.Where{ $_.IsPickList }

        # Publish dictionary
        $PublishToIndex = @{
            'All Autotask Users'  = '1'
            'Internal Users Only' = '2'
        }
    }


    process {

        # A new Attachment object
        $Attachment = New-Object "Autotask.Attachment"

        # A new AttachmentInfo object
        $AttachmentInfo = New-Object "Autotask.AttachmentInfo"

        # Attach info object to attachment object
        $Attachment.Info = $AttachmentInfo

        # Publishsettings
        $AttachmentInfo.Publish = $PublishToIndex[$Publish]

        # Attachment type
        if ($Data) {
            $Attachment.Data = $Data
            $AttachmentInfo.Type = 'FILE_ATTACHMENT'
            $AttachmentInfo.FullPath = '{0}.{1}' -F $Title, $Extension.TrimStart('.')
        }
        # Is it an URL?
        elseif ($URI) {
            if ($FolderLink.IsPresent) {
                $AttachmentInfo.Type = 'FOLDER_LINK'
            }
            elseif ($FileLink.IsPresent) {
                $AttachmentInfo.Type = 'FILE_LINK'
            }
            else {
                $AttachmentInfo.Type = 'URL'
            }
            $ATtachmentInfo.FullPath = $URI.AbsoluteUri
            $AttachmentInfo.Title = $AttachmentInfo.FullPath
        }
        # It is a file and it is going to be attached.
        else {

            $AsByteStream = @{}

            if ($PSVersionTable.PSVersion.Major -ge 5) {
                $AsByteStream.AsByteStream = $True
            }
            else {
                $AsByteStream.Encoding = 'Byte'
            }

            [Byte[]]$Data = Get-Content @AsByteStream -Path $Path.FullName  -ReadCount 0
            $Attachment.Data = $Data

            # Type is attachment
            $AttachmentInfo.Type = 'FILE_ATTACHMENT'
            $AttachmentInfo.Title = $Path.BaseName
            $AttachmentInfo.FullPath = $Path.FullName

            # Determine content type by file name
            #Region MIMEMappingTable
            $Obj = @{}
            $Obj.Add(".323", "text/h323")
            $Obj.Add(".aaf", "application/octet-stream")
            $Obj.Add(".aca", "application/octet-stream")
            $Obj.Add(".accdb", "application/msaccess")
            $Obj.Add(".accde", "application/msaccess")
            $Obj.Add(".accdt", "application/msaccess")
            $Obj.Add(".acx", "application/internet-property-stream")
            $Obj.Add(".afm", "application/octet-stream")
            $Obj.Add(".ai", "application/postscript")
            $Obj.Add(".aif", "audio/x-aiff")
            $Obj.Add(".aifc", "audio/aiff")
            $Obj.Add(".aiff", "audio/aiff")
            $Obj.Add(".application", "application/x-ms-application")
            $Obj.Add(".art", "image/x-jg")
            $Obj.Add(".asd", "application/octet-stream")
            $Obj.Add(".asf", "video/x-ms-asf")
            $Obj.Add(".asi", "application/octet-stream")
            $Obj.Add(".asm", "text/plain")
            $Obj.Add(".asr", "video/x-ms-asf")
            $Obj.Add(".asx", "video/x-ms-asf")
            $Obj.Add(".atom", "application/atom+xml")
            $Obj.Add(".au", "audio/basic")
            $Obj.Add(".avi", "video/x-msvideo")
            $Obj.Add(".axs", "application/olescript")
            $Obj.Add(".bas", "text/plain")
            $Obj.Add(".bcpio", "application/x-bcpio")
            $Obj.Add(".bin", "application/octet-stream")
            $Obj.Add(".bmp", "image/bmp")
            $Obj.Add(".c", "text/plain")
            $Obj.Add(".cab", "application/octet-stream")
            $Obj.Add(".calx", "application/vnd.ms-office.calx")
            $Obj.Add(".cat", "application/vnd.ms-pki.seccat")
            $Obj.Add(".cdf", "application/x-cdf")
            $Obj.Add(".chm", "application/octet-stream")
            $Obj.Add(".class", "application/x-java-applet")
            $Obj.Add(".clp", "application/x-msclip")
            $Obj.Add(".cmx", "image/x-cmx")
            $Obj.Add(".cnf", "text/plain")
            $Obj.Add(".cod", "image/cis-cod")
            $Obj.Add(".cpio", "application/x-cpio")
            $Obj.Add(".cpp", "text/plain")
            $Obj.Add(".crd", "application/x-mscardfile")
            $Obj.Add(".crl", "application/pkix-crl")
            $Obj.Add(".crt", "application/x-x509-ca-cert")
            $Obj.Add(".csh", "application/x-csh")
            $Obj.Add(".css", "text/css")
            $Obj.Add(".csv", "application/octet-stream")
            $Obj.Add(".cur", "application/octet-stream")
            $Obj.Add(".dcr", "application/x-director")
            $Obj.Add(".deploy", "application/octet-stream")
            $Obj.Add(".der", "application/x-x509-ca-cert")
            $Obj.Add(".dib", "image/bmp")
            $Obj.Add(".dir", "application/x-director")
            $Obj.Add(".disco", "text/xml")
            $Obj.Add(".dll", "application/x-msdownload")
            $Obj.Add(".dll.config", "text/xml")
            $Obj.Add(".dlm", "text/dlm")
            $Obj.Add(".doc", "application/msword")
            $Obj.Add(".docm", "application/vnd.ms-word.document.macroEnabled.12")
            $Obj.Add(".docx", "application/vnd.openxmlformats-officedocument.wordprocessingml.document")
            $Obj.Add(".dot", "application/msword")
            $Obj.Add(".dotm", "application/vnd.ms-word.template.macroEnabled.12")
            $Obj.Add(".dotx", "application/vnd.openxmlformats-officedocument.wordprocessingml.template")
            $Obj.Add(".dsp", "application/octet-stream")
            $Obj.Add(".dtd", "text/xml")
            $Obj.Add(".dvi", "application/x-dvi")
            $Obj.Add(".dwf", "drawing/x-dwf")
            $Obj.Add(".dwp", "application/octet-stream")
            $Obj.Add(".dxr", "application/x-director")
            $Obj.Add(".eml", "message/rfc822")
            $Obj.Add(".emz", "application/octet-stream")
            $Obj.Add(".eot", "application/octet-stream")
            $Obj.Add(".eps", "application/postscript")
            $Obj.Add(".etx", "text/x-setext")
            $Obj.Add(".evy", "application/envoy")
            $Obj.Add(".exe", "application/octet-stream")
            $Obj.Add(".exe.config", "text/xml")
            $Obj.Add(".fdf", "application/vnd.fdf")
            $Obj.Add(".fif", "application/fractals")
            $Obj.Add(".fla", "application/octet-stream")
            $Obj.Add(".flr", "x-world/x-vrml")
            $Obj.Add(".flv", "video/x-flv")
            $Obj.Add(".gif", "image/gif")
            $Obj.Add(".gtar", "application/x-gtar")
            $Obj.Add(".gz", "application/x-gzip")
            $Obj.Add(".h", "text/plain")
            $Obj.Add(".hdf", "application/x-hdf")
            $Obj.Add(".hdml", "text/x-hdml")
            $Obj.Add(".hhc", "application/x-oleobject")
            $Obj.Add(".hhk", "application/octet-stream")
            $Obj.Add(".hhp", "application/octet-stream")
            $Obj.Add(".hlp", "application/winhlp")
            $Obj.Add(".hqx", "application/mac-binhex40")
            $Obj.Add(".hta", "application/hta")
            $Obj.Add(".htc", "text/x-component")
            $Obj.Add(".htm", "text/html")
            $Obj.Add(".html", "text/html")
            $Obj.Add(".htt", "text/webviewhtml")
            $Obj.Add(".hxt", "text/html")
            $Obj.Add(".ico", "image/x-icon")
            $Obj.Add(".ics", "application/octet-stream")
            $Obj.Add(".ief", "image/ief")
            $Obj.Add(".iii", "application/x-iphone")
            $Obj.Add(".inf", "application/octet-stream")
            $Obj.Add(".ins", "application/x-internet-signup")
            $Obj.Add(".isp", "application/x-internet-signup")
            $Obj.Add(".IVF", "video/x-ivf")
            $Obj.Add(".jar", "application/java-archive")
            $Obj.Add(".java", "application/octet-stream")
            $Obj.Add(".jck", "application/liquidmotion")
            $Obj.Add(".jcz", "application/liquidmotion")
            $Obj.Add(".jfif", "image/pjpeg")
            $Obj.Add(".jpb", "application/octet-stream")
            $Obj.Add(".jpe", "image/jpeg")
            $Obj.Add(".jpeg", "image/jpeg")
            $Obj.Add(".jpg", "image/jpeg")
            $Obj.Add(".js", "application/x-javascript")
            $Obj.Add(".jsx", "text/jscript")
            $Obj.Add(".latex", "application/x-latex")
            $Obj.Add(".lit", "application/x-ms-reader")
            $Obj.Add(".lpk", "application/octet-stream")
            $Obj.Add(".lsf", "video/x-la-asf")
            $Obj.Add(".lsx", "video/x-la-asf")
            $Obj.Add(".lzh", "application/octet-stream")
            $Obj.Add(".m13", "application/x-msmediaview")
            $Obj.Add(".m14", "application/x-msmediaview")
            $Obj.Add(".m1v", "video/mpeg")
            $Obj.Add(".m3u", "audio/x-mpegurl")
            $Obj.Add(".man", "application/x-troff-man")
            $Obj.Add(".manifest", "application/x-ms-manifest")
            $Obj.Add(".map", "text/plain")
            $Obj.Add(".mdb", "application/x-msaccess")
            $Obj.Add(".mdp", "application/octet-stream")
            $Obj.Add(".me", "application/x-troff-me")
            $Obj.Add(".mht", "message/rfc822")
            $Obj.Add(".mhtml", "message/rfc822")
            $Obj.Add(".mid", "audio/mid")
            $Obj.Add(".midi", "audio/mid")
            $Obj.Add(".mix", "application/octet-stream")
            $Obj.Add(".mmf", "application/x-smaf")
            $Obj.Add(".mno", "text/xml")
            $Obj.Add(".mny", "application/x-msmoney")
            $Obj.Add(".mov", "video/quicktime")
            $Obj.Add(".movie", "video/x-sgi-movie")
            $Obj.Add(".mp2", "video/mpeg")
            $Obj.Add(".mp3", "audio/mpeg")
            $Obj.Add(".mpa", "video/mpeg")
            $Obj.Add(".mpe", "video/mpeg")
            $Obj.Add(".mpeg", "video/mpeg")
            $Obj.Add(".mpg", "video/mpeg")
            $Obj.Add(".mpp", "application/vnd.ms-project")
            $Obj.Add(".mpv2", "video/mpeg")
            $Obj.Add(".ms", "application/x-troff-ms")
            $Obj.Add(".msi", "application/octet-stream")
            $Obj.Add(".mso", "application/octet-stream")
            $Obj.Add(".mvb", "application/x-msmediaview")
            $Obj.Add(".mvc", "application/x-miva-compiled")
            $Obj.Add(".nc", "application/x-netcdf")
            $Obj.Add(".nsc", "video/x-ms-asf")
            $Obj.Add(".nws", "message/rfc822")
            $Obj.Add(".ocx", "application/octet-stream")
            $Obj.Add(".oda", "application/oda")
            $Obj.Add(".odc", "text/x-ms-odc")
            $Obj.Add(".ods", "application/oleobject")
            $Obj.Add(".one", "application/onenote")
            $Obj.Add(".onea", "application/onenote")
            $Obj.Add(".onetoc", "application/onenote")
            $Obj.Add(".onetoc2", "application/onenote")
            $Obj.Add(".onetmp", "application/onenote")
            $Obj.Add(".onepkg", "application/onenote")
            $Obj.Add(".osdx", "application/opensearchdescription+xml")
            $Obj.Add(".p10", "application/pkcs10")
            $Obj.Add(".p12", "application/x-pkcs12")
            $Obj.Add(".p7b", "application/x-pkcs7-certificates")
            $Obj.Add(".p7c", "application/pkcs7-mime")
            $Obj.Add(".p7m", "application/pkcs7-mime")
            $Obj.Add(".p7r", "application/x-pkcs7-certreqresp")
            $Obj.Add(".p7s", "application/pkcs7-signature")
            $Obj.Add(".pbm", "image/x-portable-bitmap")
            $Obj.Add(".pcx", "application/octet-stream")
            $Obj.Add(".pcz", "application/octet-stream")
            $Obj.Add(".pdf", "application/pdf")
            $Obj.Add(".pfb", "application/octet-stream")
            $Obj.Add(".pfm", "application/octet-stream")
            $Obj.Add(".pfx", "application/x-pkcs12")
            $Obj.Add(".pgm", "image/x-portable-graymap")
            $Obj.Add(".pko", "application/vnd.ms-pki.pko")
            $Obj.Add(".pma", "application/x-perfmon")
            $Obj.Add(".pmc", "application/x-perfmon")
            $Obj.Add(".pml", "application/x-perfmon")
            $Obj.Add(".pmr", "application/x-perfmon")
            $Obj.Add(".pmw", "application/x-perfmon")
            $Obj.Add(".png", "image/png")
            $Obj.Add(".pnm", "image/x-portable-anymap")
            $Obj.Add(".pnz", "image/png")
            $Obj.Add(".pot", "application/vnd.ms-powerpoint")
            $Obj.Add(".potm", "application/vnd.ms-powerpoint.template.macroEnabled.12")
            $Obj.Add(".potx", "application/vnd.openxmlformats-officedocument.presentationml.template")
            $Obj.Add(".ppam", "application/vnd.ms-powerpoint.$Obj.Addin.macroEnabled.12")
            $Obj.Add(".ppm", "image/x-portable-pixmap")
            $Obj.Add(".pps", "application/vnd.ms-powerpoint")
            $Obj.Add(".ppsm", "application/vnd.ms-powerpoint.slideshow.macroEnabled.12")
            $Obj.Add(".ppsx", "application/vnd.openxmlformats-officedocument.presentationml.slideshow")
            $Obj.Add(".ppt", "application/vnd.ms-powerpoint")
            $Obj.Add(".pptm", "application/vnd.ms-powerpoint.presentation.macroEnabled.12")
            $Obj.Add(".pptx", "application/vnd.openxmlformats-officedocument.presentationml.presentation")
            $Obj.Add(".prf", "application/pics-rules")
            $Obj.Add(".prm", "application/octet-stream")
            $Obj.Add(".prx", "application/octet-stream")
            $Obj.Add(".ps", "application/postscript")
            $Obj.Add(".psd", "application/octet-stream")
            $Obj.Add(".psm", "application/octet-stream")
            $Obj.Add(".psp", "application/octet-stream")
            $Obj.Add(".pub", "application/x-mspublisher")
            $Obj.Add(".qt", "video/quicktime")
            $Obj.Add(".qtl", "application/x-quicktimeplayer")
            $Obj.Add(".qxd", "application/octet-stream")
            $Obj.Add(".ra", "audio/x-pn-realaudio")
            $Obj.Add(".ram", "audio/x-pn-realaudio")
            $Obj.Add(".rar", "application/octet-stream")
            $Obj.Add(".ras", "image/x-cmu-raster")
            $Obj.Add(".rf", "image/vnd.rn-realflash")
            $Obj.Add(".rgb", "image/x-rgb")
            $Obj.Add(".rm", "application/vnd.rn-realmedia")
            $Obj.Add(".rmi", "audio/mid")
            $Obj.Add(".roff", "application/x-troff")
            $Obj.Add(".rpm", "audio/x-pn-realaudio-plugin")
            $Obj.Add(".rtf", "application/rtf")
            $Obj.Add(".rtx", "text/richtext")
            $Obj.Add(".scd", "application/x-msschedule")
            $Obj.Add(".sct", "text/scriptlet")
            $Obj.Add(".sea", "application/octet-stream")
            $Obj.Add(".setpay", "application/set-payment-initiation")
            $Obj.Add(".setreg", "application/set-registration-initiation")
            $Obj.Add(".sgml", "text/sgml")
            $Obj.Add(".sh", "application/x-sh")
            $Obj.Add(".shar", "application/x-shar")
            $Obj.Add(".sit", "application/x-stuffit")
            $Obj.Add(".sldm", "application/vnd.ms-powerpoint.slide.macroEnabled.12")
            $Obj.Add(".sldx", "application/vnd.openxmlformats-officedocument.presentationml.slide")
            $Obj.Add(".smd", "audio/x-smd")
            $Obj.Add(".smi", "application/octet-stream")
            $Obj.Add(".smx", "audio/x-smd")
            $Obj.Add(".smz", "audio/x-smd")
            $Obj.Add(".snd", "audio/basic")
            $Obj.Add(".snp", "application/octet-stream")
            $Obj.Add(".spc", "application/x-pkcs7-certificates")
            $Obj.Add(".spl", "application/futuresplash")
            $Obj.Add(".src", "application/x-wais-source")
            $Obj.Add(".ssm", "application/streamingmedia")
            $Obj.Add(".sst", "application/vnd.ms-pki.certstore")
            $Obj.Add(".stl", "application/vnd.ms-pki.stl")
            $Obj.Add(".sv4cpio", "application/x-sv4cpio")
            $Obj.Add(".sv4crc", "application/x-sv4crc")
            $Obj.Add(".swf", "application/x-shockwave-flash")
            $Obj.Add(".t", "application/x-troff")
            $Obj.Add(".tar", "application/x-tar")
            $Obj.Add(".tcl", "application/x-tcl")
            $Obj.Add(".tex", "application/x-tex")
            $Obj.Add(".texi", "application/x-texinfo")
            $Obj.Add(".texinfo", "application/x-texinfo")
            $Obj.Add(".tgz", "application/x-compressed")
            $Obj.Add(".thmx", "application/vnd.ms-officetheme")
            $Obj.Add(".thn", "application/octet-stream")
            $Obj.Add(".tif", "image/tiff")
            $Obj.Add(".tiff", "image/tiff")
            $Obj.Add(".toc", "application/octet-stream")
            $Obj.Add(".tr", "application/x-troff")
            $Obj.Add(".trm", "application/x-msterminal")
            $Obj.Add(".tsv", "text/tab-separated-values")
            $Obj.Add(".ttf", "application/octet-stream")
            $Obj.Add(".txt", "text/plain")
            $Obj.Add(".u32", "application/octet-stream")
            $Obj.Add(".uls", "text/iuls")
            $Obj.Add(".ustar", "application/x-ustar")
            $Obj.Add(".vbs", "text/vbscript")
            $Obj.Add(".vcf", "text/x-vcard")
            $Obj.Add(".vcs", "text/plain")
            $Obj.Add(".vdx", "application/vnd.ms-visio.viewer")
            $Obj.Add(".vml", "text/xml")
            $Obj.Add(".vsd", "application/vnd.visio")
            $Obj.Add(".vss", "application/vnd.visio")
            $Obj.Add(".vst", "application/vnd.visio")
            $Obj.Add(".vsto", "application/x-ms-vsto")
            $Obj.Add(".vsw", "application/vnd.visio")
            $Obj.Add(".vsx", "application/vnd.visio")
            $Obj.Add(".vtx", "application/vnd.visio")
            $Obj.Add(".wav", "audio/wav")
            $Obj.Add(".wax", "audio/x-ms-wax")
            $Obj.Add(".wbmp", "image/vnd.wap.wbmp")
            $Obj.Add(".wcm", "application/vnd.ms-works")
            $Obj.Add(".wdb", "application/vnd.ms-works")
            $Obj.Add(".wks", "application/vnd.ms-works")
            $Obj.Add(".wm", "video/x-ms-wm")
            $Obj.Add(".wma", "audio/x-ms-wma")
            $Obj.Add(".wmd", "application/x-ms-wmd")
            $Obj.Add(".wmf", "application/x-msmetafile")
            $Obj.Add(".wml", "text/vnd.wap.wml")
            $Obj.Add(".wmlc", "application/vnd.wap.wmlc")
            $Obj.Add(".wmls", "text/vnd.wap.wmlscript")
            $Obj.Add(".wmlsc", "application/vnd.wap.wmlscriptc")
            $Obj.Add(".wmp", "video/x-ms-wmp")
            $Obj.Add(".wmv", "video/x-ms-wmv")
            $Obj.Add(".wmx", "video/x-ms-wmx")
            $Obj.Add(".wmz", "application/x-ms-wmz")
            $Obj.Add(".wps", "application/vnd.ms-works")
            $Obj.Add(".wri", "application/x-mswrite")
            $Obj.Add(".wrl", "x-world/x-vrml")
            $Obj.Add(".wrz", "x-world/x-vrml")
            $Obj.Add(".wsdl", "text/xml")
            $Obj.Add(".wvx", "video/x-ms-wvx")
            $Obj.Add(".x", "application/directx")
            $Obj.Add(".xaf", "x-world/x-vrml")
            $Obj.Add(".xaml", "application/xaml+xml")
            $Obj.Add(".xap", "application/x-silverlight-app")
            $Obj.Add(".xbap", "application/x-ms-xbap")
            $Obj.Add(".xbm", "image/x-xbitmap")
            $Obj.Add(".xdr", "text/plain")
            $Obj.Add(".xla", "application/vnd.ms-excel")
            $Obj.Add(".xlam", "application/vnd.ms-excel.$Obj.Addin.macroEnabled.12")
            $Obj.Add(".xlc", "application/vnd.ms-excel")
            $Obj.Add(".xlm", "application/vnd.ms-excel")
            $Obj.Add(".xls", "application/vnd.ms-excel")
            $Obj.Add(".xlsb", "application/vnd.ms-excel.sheet.binary.macroEnabled.12")
            $Obj.Add(".xlsm", "application/vnd.ms-excel.sheet.macroEnabled.12")
            $Obj.Add(".xlsx", "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet")
            $Obj.Add(".xlt", "application/vnd.ms-excel")
            $Obj.Add(".xltm", "application/vnd.ms-excel.template.macroEnabled.12")
            $Obj.Add(".xltx", "application/vnd.openxmlformats-officedocument.spreadsheetml.template")
            $Obj.Add(".xlw", "application/vnd.ms-excel")
            $Obj.Add(".xml", "text/xml")
            $Obj.Add(".xof", "x-world/x-vrml")
            $Obj.Add(".xpm", "image/x-xpixmap")
            $Obj.Add(".xps", "application/vnd.ms-xpsdocument")
            $Obj.Add(".xsd", "text/xml")
            $Obj.Add(".xsf", "text/xml")
            $Obj.Add(".xsl", "text/xml")
            $Obj.Add(".xslt", "text/xml")
            $Obj.Add(".xsn", "application/octet-stream")
            $Obj.Add(".xtp", "application/octet-stream")
            $Obj.Add(".xwd", "image/x-xwindowdump")
            $Obj.Add(".z", "application/x-compress")
            $Obj.Add(".zip", "application/x-zip-compressed")

            #EndRegion
            $AttachmentInfo.ContentType = $Obj.($Path.Extension.ToLower())

        }

        # Overwrite title with $Title if it exists
        if ($Title) {
            $AttachmentInfo.Title = $Title
        }

        # What are we attaching to?
        $objectType = ($PSCmdlet.ParameterSetName -split '_')[0]

        $AttachmentInfo.ParentId = $TicketId + $AccountID + $ProjectID + $OpportunityId
        $AttachmentInfo.ParentType = $Picklists.Where{ $_.name -eq 'ParentType' }.PickListValues.Where{ $_.Label -eq $objectType }.Value

        # Prepare ShouldProcess
        $caption = $MyInvocation.MyCommand.Name
        $verboseDescription = '{0}: About to create an attachment of type {1} with title {2}.' -F $caption, $AttachmentInfo.Type, $AttachmentInfo.Title
        $verboseWarning = '{0}: About to create an attachment of type {1} with title {2}. Do you want to continue?' -F $caption, $AttachmentInfo.Type, $AttachmentInfo.Title

        # Do it, I dare you!
        if ($PSCmdlet.ShouldProcess($verboseDescription, $verboseWarning, $caption)) {
            $AttachmentId = $Script:Atws.CreateAttachment($Script:Atws.integrationsValue, $Attachment)

            $result = Get-AtwsAttachmentInfo -id $AttachmentId

            Write-Verbose ('{0}: Created attachment with id {1} and title {2}' -F $MyInvocation.MyCommand.Name, $AttachmentId, $result.Title)

        }
    }

    end {
        Write-Debug ('{0}: End of function' -F $MyInvocation.MyCommand.Name)
        if ($result) {
            Return $result
        }
    }


}
