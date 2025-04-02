#!/usr/bin/awk -f
#
# Copyright (C) 2025 Serghei Iakovlev <gnu@serghei.pl>
#
# This file is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 3
# of the License, or (at your option) any later version.
#
# This file is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this file.  If not, see <https://www.gnu.org/licenses/>.

# Git Contribution Statistics Processor (POSIX-compliant)
# Version: 2.2
#
# DESCRIPTION:
#   Processes git log output to generate author contribution statistics.
#   Supports name normalization through mappings to consolidate commits from
#   different usernames/emails to a single identity.
#
# USAGE:
#   Direct:
#     git log --pretty="%aN" --numstat | git-stat.awk [OPTIONS] [MAPPINGS...]
#
#   Via git alias:
#     git stats [GIT_ARGS] -- [SCRIPT_OPTIONS] [MAPPINGS...]
#
# OPTIONS:
#   -c           Enable case-sensitive pattern matching (default: case-insensitive)
#   -s COLUMN    Sort by column: 2=lines added, 3=lines removed, 4=total (default: 2)
#   -r           Use ascending sort order (default: descending)
#   --help       Display help information
#
# MAPPINGS:
#   Format: "Display Name:pattern1,pattern2,..."
#   Example: "John Doe:john.doe,jdoe,johnd"
#
# EXAMPLES:
#   git stats -- "John Doe:johnd,john.doe" "Jane Smith:jsmith,jane"
#   git stats -- -s4        # Sort by total lines
#   git stats -- -r -s3     # Sort by lines removed, ascending order

BEGIN {
    # Configuration defaults
    OFS = "|"
    sort_column = 2    # 2=added, 3=removed, 4=total
    reverse = 1        # 1=descending, 0=ascending
    case_sensitive = 0 # 0=case-insensitive, 1=case-sensitive
    filter_invalid = 1 # Skip names starting with "-"

    # Internal state
    maxlen = 0
    count = 0

    # Parse command-line arguments
    for (i = 1; i < ARGC; i++) {
        if (ARGV[i] == "--help") {
            print_help()
            exit 0
        }
        else if (ARGV[i] == "-c") case_sensitive = 1
        else if (ARGV[i] == "-r") reverse = 0
        else if (ARGV[i] == "-s" && i+1 < ARGC) sort_column = ARGV[++i] + 0
        else if (ARGV[i] ~ /^-/) {
            print "Invalid option: " ARGV[i] > "/dev/stderr"
            exit 1
        }
        else process_mapping(ARGV[i])
    }
    ARGC = 1 # Prevent AWK from processing remaining arguments as files
}

function print_help() {
    print "Git Contribution Statistics Processor"
    print "Usage: git log [...] | git-contrib-stats.awk [OPTIONS] [MAPPINGS...]"
    print "\nOptions:"
    print "  -c           Case-sensitive pattern matching"
    print "  -s COLUMN    Sort column (2=+added, 3=-removed, 4=total)"
    print "  -r           Reverse sort order (ascending)"
    print "  --help       Show this help"
    print "\nMappings format: \"Display Name:pattern1,pattern2...\""
    print "Multiple patterns require ALL matches (AND logic)"
}

function process_mapping(mapping, parts, n, canonical, patterns, i) {
    n = split(mapping, parts, /:/)
    if (n < 2) {
        print "Invalid mapping: " mapping > "/dev/stderr"
        return
    }

    canonical = parts[1]
    patterns = substr(mapping, length(parts[1]) + 2)

    if (!canonical || !patterns) {
        print "Invalid mapping format: " mapping > "/dev/stderr"
        return
    }

    n = split(patterns, pattern_array, /,/)
    mapping_count[canonical] = n
    for (i = 1; i <= n; i++) {
        # Use composite key for POSIX compliance
        mappings[canonical SUBSEP i] = case_sensitive ? pattern_array[i] : tolower(pattern_array[i])
    }
}

function normalize(name, lower, canonical, i, matches, pattern) {
    lower = case_sensitive ? name : tolower(name)

    for (canonical in mapping_count) {
        matches = 0
        for (i = 1; i <= mapping_count[canonical]; i++) {
            pattern = mappings[canonical SUBSEP i]
            if (lower ~ pattern) matches++
        }
        if (matches == mapping_count[canonical]) {
            return canonical
        }
    }
    return name
}

# Process git log output
/^[^0-9]/ { # Author line
    author = normalize($0)
    next
}

/^[0-9]+\t[0-9]+/ { # Numstat line
    if (author && (filter_invalid ? (substr(author,1,1) != "-") : 1)) {
        added[author] += $1
        removed[author] += $2
        total[author] = added[author] + removed[author]
    }
    next
}

END {
    # Collect valid authors
    for (a in added) {
        if (filter_invalid && substr(a,1,1) == "-") continue
        authors[++count] = a
        maxlen = length(a) > maxlen ? length(a) : maxlen
    }

    # Bubble sort by selected column
    for (i = 1; i <= count; i++) {
        for (j = i + 1; j <= count; j++) {
            a = authors[i]
            b = authors[j]

            # Determine comparison value
            cmp = 0
            if (sort_column == 2) cmp = added[a] < added[b]
            else if (sort_column == 3) cmp = removed[a] < removed[b]
            else if (sort_column == 4) cmp = total[a] < total[b]
            else cmp = a < b

            # Apply reverse order
            if (reverse ? cmp : !cmp) {
                tmp = authors[i]
                authors[i] = authors[j]
                authors[j] = tmp
            }
        }
    }

    # Format output
    fmt = "%-" maxlen "s  +%-7d  -%-7d  total: %d\n"
    for (i = 1; i <= count; i++) {
        a = authors[i]
        printf fmt, a, added[a], removed[a], total[a]
    }
}
