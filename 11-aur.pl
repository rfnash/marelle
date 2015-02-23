%
%  11-aur.pl
%  marelle-deps
%

% installs_with_aur(Pkg).
%   Pkg installs with aur package of same name on all Archlinux flavours 
:- multifile installs_with_aur/1.

% installs_with_aur(Pkg, PacName).
%   Pkg installs with aur package called PacName on all Archlinux
%   flavours. PacName can also be a list of packages.
:- multifile installs_with_aur/2.

installs_with_aur(P, P) :- installs_with_aur(P).

% installs_with_aur(Pkg, Codename, PacName).
%   Pkg installs with aur package called PacName on given Archlinux
%   variant with given Codename.
:- multifile installs_with_aur/3.

installs_with_aur(P, _, PacName) :- installs_with_aur(P, PacName).

met(P, linux(Codename)) :-
    isfile('/usr/sbin/yaourt'),
    installs_with_aur(P, Codename, PkgName), !,
    ( is_list(PkgName) ->
        maplist(check_aur, PkgName)
    ;
        check_aur(PkgName)
    ).

meet(P, linux(Codename)) :-
    isfile('/usr/sbin/yaourt'),
    installs_with_aur(P, Codename, PkgName), !,
    ( is_list(PkgName) ->
        maplist(install_aur, PkgName)
    ;
        install_aur(PkgName)
    ).

% succeed only if the package is already installed
check_aur(Pkg) :-
    bash(['pacman -Qmi ', Pkg, '>/dev/null 2>/dev/null']).

% attempt to install a package with yaourt
install_aur(Pkg) :-
    bash(['yaourt -S --noconfirm ', Pkg]).

