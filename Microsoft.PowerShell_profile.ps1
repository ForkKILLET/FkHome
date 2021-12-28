cls
echo ForkKILLET@hswt

$env:FK = "C:\fk"
$env:VIMFILES = "$Home\vimfiles"
$env:VIMRC = "$Home\vimfiles\vimrc"
$env:WILLBOT_HOME = "$env:FK\src\willbot\src\config.json"

function vp() {
	vim $PROFILE
	refreshenv
	. $PROFILE
}
function vv() {		vim $env:VIMRC }
function vl() {		vim C:\fk\log }

function cdf() {	cd $env:FK }
function cdd() {	cd "$env:FK/_" }
function cds() {	cd "$env:FK/src" }
function cdv() {	cd "$env:VIMFILES" }

function ..() {		cd.. }
