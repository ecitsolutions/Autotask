#requires -modules platyps
# Copyright (c) 2021 klemmestad
#
# This software is released under the MIT License.
#
# https://github.com/karamem0/SPClientCore/blob/master/LICENSE
#

$modulePath = join-path -Path $PSScriptRoot -ChildPath '..' -AdditionalChildPath 'Autotask'
$docPath = Join-Path -Path $PSScriptRoot -ChildPath '..' -AdditionalChildPath 'docs'
$extHelpPath = Join-Path -Path $modulePath -ChildPath 'en-US'

import-module $modulePath -force

New-MarkdownHelp -Module Autotask -OutputFolder $docPath -Force
New-ExternalHelp -Path $docPath -OutputPath $extHelpPath -Force

