#!/bin/bash -e

########################
# FILE LOCAL UTILITIES #
########################

function appendToFileIfNotFound()
{
    local file="${1}"
    local pattern="${2}"
    local string="${3}"
    local patternAsRegex="${4}"
    local stringAsRegex="${5}"

    if [[ -f "${file}" ]]
    then
        local grepOption='--fixed-strings --only-matching'

        if [[ "${patternAsRegex}" = 'true' ]]
        then
            grepOption='--extended-regexp --only-matching'
        fi

        local found="$(grep "${grepOption}" "${pattern}" "${file}")"

        if [[ "$(isEmptyString "${found}")" = 'true' ]]
        then
            if [[ "${stringAsRegex}" = 'true' ]]
            then
                echo -e "${string}" >> "${file}"
            else
                echo >> "${file}"
                echo "${string}" >> "${file}"
            fi
        fi
    else
        fatal "FATAL: file '${file}' not found!"
    fi
}

####################
# STRING UTILITIES #
####################

function error()
{
    echo -e "\033[1;31m${1}\033[0m" 1>&2
}

function fatal()
{
    error "${1}"
    exit 1
}

function isEmptyString()
{
    if [[ "$(trimString ${1})" = '' ]]
    then
        echo 'true'
    else
        echo 'false'
    fi
}

function trimString()
{
    echo "${1}" | sed --expression 's/^ *//g' --expression 's/ *$//g'
}

####################
# SYSTEM UTILITIES #
####################

function checkRequireRootUser()
{
    checkRequireUser 'root'
}

function checkRequireUser()
{
    local user="${1}"

    if [[ "$(whoami)" != "${user}" ]]
    then
        fatal "\nFATAL: please run this program as '${user}' user!"
    fi
}