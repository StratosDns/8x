# simple_grammar_parser.py

# Λεξικά για ανίχνευση αριθμού
singular_nouns = {"dog", "cat", "boy", "girl"}
plural_nouns = {"dogs", "cats", "boys", "girls"}
singular_verbs = {"chases", "sees", "says", "believes"}
plural_verbs = {"chase", "see", "say", "believe"}
dets = {"a", "the", ""}

def det(word):
    return word in dets

def noun(word):
    if word in singular_nouns:
        return "sg"
    elif word in plural_nouns:
        return "pl"
    else:
        return None

def verb(word):
    if word in singular_verbs:
        return "sg"
    elif word in plural_verbs:
        return "pl"
    else:
        return None

def np(words):
    """ Returns (arithmetic_number, rest_words) if match, else None """
    if len(words) == 0:
        return None
    # Det + Noun
    if words[0] in dets:
        det_word = words[0]
        if det_word == "a" and (len(words) < 2 or noun(words[1]) != "sg"):
            return None  # 'a' χρησιμοποιείται μόνο με ενικό
        if len(words) >= 2 and noun(words[1]):
            return noun(words[1]), words[2:]
        else:
            return None
    # Μόνο Noun (χωρίς Det)
    elif noun(words[0]):
        return noun(words[0]), words[1:]
    else:
        return None

def vp(words):
    """ VP -> V NP | V """
    # Προσπάθησε το VP -> V NP
    if len(words) >= 2 and verb(words[0]):
        v_num = verb(words[0])
        np_res = np(words[1:])
        if np_res:
            _, rest = np_res
            return v_num, rest
    # VP -> V
    if len(words) >= 1 and verb(words[0]):
        v_num = verb(words[0])
        return v_num, words[1:]
    return None

def s(words):
    """ S -> NP VP """
    np_res = np(words)
    if np_res:
        subj_num, rest = np_res
        vp_res = vp(rest)
        if vp_res:
            verb_num, rest2 = vp_res
            if subj_num == verb_num and len(rest2) == 0:
                return True
    return False

def is_valid_sentence(sentence):
    # Επέτρεψε 'the', 'a', η τίποτα ως Det (σε lower case)
    tokens = sentence.strip().lower().replace(".", "").split()
    # Υποστήριξη για 'τίποτα' -- αν η πρόταση ξεκινά με N χωρίς Det
    # Ή ' ' ως Det
    return s(tokens)

if __name__ == "__main__":
    examples = [
        "The dog chases cats.",    # σωστό
        "The dog chase cats.",     # λάθος
        "A boy sees a girl.",      # σωστό
        "Boys see a cat.",         # σωστό
        "The boys sees the cats.", # λάθος
        "Girls say.",              # σωστό
        "The cat say.",            # λάθος
        "Dogs believe girls.",     # σωστό
        "Cats chases boys.",       # λάθος
        "Dog says.",               # σωστό
        "The dogs chase.",         # σωστό
    ]
    for sent in examples:
        print(f"\"{sent}\" --> {is_valid_sentence(sent)}")