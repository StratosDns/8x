% grammar.pl

% Η βασική πρόταση: S -> NP VP, όπου το NP και το ρήμα στη VP πρέπει να συμφωνούν σε αριθμό
s --> np(Number), vp(Number).

% NP -> Det N
np(Number) --> det(DetType, Number), n(Number).
% NP μπορεί να είναι και μόνο το ουσιαστικό (χωρίς Det)
np(Number) --> n(Number).

% VP -> V NP | V
vp(Number) --> v(Number), np(_).     % Ο αριθμός του αντικειμένου αδιάφορος
vp(Number) --> v(Number).

% Det μπορεί να είναι "a", "the", ή τίποτα (εφόσον το επόμενο είναι ουσιαστικό)
det(a, sg)   --> [a].         % 'a' μόνο με ενικό
det(the, _)  --> [the].
det(none, _) --> [].          % 'τίποτα' ως Det

% Ουσιαστικά, με ετικέτα αριθμού
n(sg) --> [dog].
n(sg) --> [cat].
n(sg) --> [boy].
n(sg) --> [girl].
n(pl) --> [dogs].
n(pl) --> [cats].
n(pl) --> [boys].
n(pl) --> [girls].

% Ρήματα, με ετικέτα αριθμού
v(sg) --> [chases].
v(sg) --> [sees].
v(sg) --> [says].
v(sg) --> [believes].
v(pl) --> [chase].
v(pl) --> [see].
v(pl) --> [say].
v(pl) --> [believe].

