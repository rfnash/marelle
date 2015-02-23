%
%  08-xbps.pl
%  marelle-deps
%

% installs_with_xbps(Pkg).
%   Pkg installs with apt package of same name on all Ubuntu/Debian flavours
:- multifile installs_with_xbps/1.

% installs_with_xbps(Pkg, PacName).
%   Pkg installs with apt package called AptName on all Ubuntu/Debian
%   flavours. PacName can also be a list of packages.
:- multifile installs_with_xbps/2.

installs_with_xbps(P, P) :- installs_with_xbps(P).

:- dynamic xbps_updated/0.

pkg('xbps-update').
met('xbps-update', linux(void)) :- xbps_updated.
meet('xbps-update', linux(void)) :-
sh('sudo xbps-install -Syu'),
assertz(xbps_updated).

depends(P, linux(void), ['xbps-update']) :-
    installs_with_xbps(P, _).

% attempt to install a package with xbps
install_xbps(Pkg) :-
    sudo_or_empty(Sudo),
    sh([Sudo, 'xbps-install -y ', Pkg]).

% succeed only if the package is already installed
check_xbps(Pkg) :-
    sh(['xbps-query ', Pkg, '>/dev/null 2>/dev/null']).

met(P, linux(void)) :-
    installs_with_xbps(P, PkgName), !,
    check_xbps(PkgName).

meet(P, linux(void)) :-
    installs_with_xbps(P, PkgName), !,
    install_xbps(PkgName).
