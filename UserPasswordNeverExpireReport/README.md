# Report to find Users with Passwords that Never Expire

This is a basic script that will identify any accounts in an Active Directory domain that have password set with the *Password never expires* checkbox set. Once identified, it will produce a report, which can either be saved into a HTML file. It can also automatically remove the checkbox, but this may not be suitable in many cases.

Whilst we would normally expect an organization would already know about these, this can be useful for auditing purposes, or to tidy up where bad security practices are/have been present in an organization.

This script has been left basic in form, but easily customizable to individual needs. For Powershell Novices, this is also demonstrates various techniques and tricks which might be applicable elsewhere including Splatting, building basic HTML structures with loops, sending emails, and filtering objects from a list by recreating it by filtering it through Where-Object.

## Setup

1. Ensure **ActiveDirectory** Powershell module is installed
2. Update the Common Variables at the start of the script, including any OUs that are to be searched
3. If necessary, uncomment Line 53 to automatically remove the *Password never expires* flag. Remove with caution

## Example

![Report Example](https://raw.githubusercontent.com/ssennettau/Powershell/master/UserPasswordNeverExpireReport/Example.PNG "Report Example")
