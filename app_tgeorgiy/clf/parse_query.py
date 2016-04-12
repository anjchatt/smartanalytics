
# coding: utf-8

# In[8]:

from pycorenlp import StanfordCoreNLP
from nltk import tree
import re

nlp = StanfordCoreNLP('http://localhost:9000')

with open('../../data_analysis/PCI/kwords.json', 'r') as f:
    s = ' '.join([l for l in f])
    kw = eval(s)
params_kw = {kw_['name']:kw_['keywords'] for kw_ in kw if kw_['group'] == 'parameter'}


# In[9]:

filter_kw = {}
for kw_ in kw:
    if kw_['group'] == 'parameter':
        filter_kw[kw_['name']] = {'keywords':kw_['keywords'], 'type':kw_['type']}
        if 'categories' in kw_:
            filter_kw[kw_['name']]['categories'] = kw_['categories']
        else:
            filter_kw[kw_['name']]['condition_kw'] = kw_['condition_kw']
        if 'default' in kw_:
            filter_kw[kw_['name']]['default'] = kw_['default']
        if 'sql_group_by' in kw_:
            filter_kw[kw_['name']]['sql_group_by'] = kw_['sql_group_by']
        


# In[10]:

def find_group(itree,pos=[]):
    if not isinstance(itree, unicode):
        if itree.label() == 'IN':
            if itree[0].lower() == 'by':
                return pos
        else:
            i = 0
            for subtree in itree:
                res = find_group(subtree,pos+[i])
                i += 1
                if not res is None:
                    return res
    return None 

def find_token_id(target_boundaries, tokens):
    for t in tokens:
        if target_boundaries[1]<=t[3] and target_boundaries[1]>t[2]:
            return(t[1]-1)

def get_all_nps(itree, l=[]):
    if not isinstance(itree, unicode):
        if itree.label() == 'NP':
            if len(itree) == 1 and itree[0].label() == 'PRP':
                return l
            l2 = len(l)
            for subtree in itree:
                l = get_all_nps(subtree, l)
            if l2 == len(l):
                l.append(itree)
        else:
            if itree.label() == 'PP' and itree.height() <= 3:
                l.append(itree)
            else:
                for subtree in itree:
                    l = get_all_nps(subtree, l)
    return l

def get_first_np(itree):
    if not isinstance(itree, unicode):
        if itree.label() == 'NP':
            if len(itree) == 1 and itree[0].label() == 'PRP':
                return 0
            for subtree in itree:
                res = get_first_np(subtree)
                if res:
                    return res
            return itree
        else:
            for subtree in itree:
                res = get_first_np(subtree)
                if res:
                    return res
    return 0

def match_param(string):
    for p_name, p_vals in params_kw.iteritems():
        for p_val in p_vals:
            if re.search(p_val,string):
                return (p_val,p_name)
    return ('','')

def match_filter(string):
    result = []
    for p_name, p_vals in filter_kw.iteritems():
        
        for p_val in p_vals['keywords']:
            result += [(p_name, m.start(), m.end()) for m in re.finditer(p_val, string)]
            #if re.findall(p_val,w):
            #    result.append(p_name)
            #    break
    return result

def match_categories(string, cats):
    ocats = []
    for cat_name,cat_kw_list in cats.iteritems():
        for kw in cat_kw_list:
            if re.search(kw, string):
                ocats.append(cat_name)
    return ocats

def preproc(istr):
    ostr = re.sub(r'((?=\D) %|% (?=\D))', ' percentage ', istr)
    #ostr = re.sub(r'(?i)\b(I|me|we|us|you)\b', '', istr)
    return ostr


# In[20]:

def parse_it(text):
    text2 = preproc(text)
    
    if(len(re.findall(r'\w+', text2)) < 3): # too few words 
        return None

    output = nlp.annotate(text2, properties={
      'annotators': 'parse',
      'outputFormat': 'json'
      })
    oresult = output['sentences'][0]
    result = oresult['parse']
    mytree = tree.Tree.fromstring(result)
    parameters = {}
    target = ('','')

    first_char_id = oresult[u'tokens'][0]['characterOffsetBegin']
    tokens = [(t[u'originalText'],
       t[u'index'],
       t[u'characterOffsetBegin']-first_char_id,
       t[u'characterOffsetEnd']-first_char_id) for t in oresult[u'tokens']]

    deps = oresult['collapsed-ccprocessed-dependencies']

    original_text = ''
    index_ = 0
    for t in tokens:
        nspaces = t[2]-index_
        index_ = t[3]
        original_text += ' '*nspaces + t[0]

    # parsing sentence type
    if mytree[0].label()=='SBARQ':
        if mytree[0][0].label()=='WHNP':
            if mytree[0][0][0].label()=='WP':
                if mytree[0][0][0][0].lower() == 'who':
                    parameters['mode'] = 'model'
                    # print 'Who'
                    # print('-- run np search for target --')
                else:
                    pass
                    # print 'What1'
                    # print('-- run np search for target --')

                # question body #
            elif mytree[0][0][0].label()=='WHNP' and mytree[0][0][0][0].label()=='WHADJP':
                parameters['mode'] = 'query'
                parameters['aggregation'] = 'count'
                st = mytree[0][0][0].flatten()
                for i in range(len(st)):
                    target = match_param(st[-i-1])
                    if target[0]:
                        break
                # print('-- run np search for target --')

            elif mytree[0][0][0].label()=='WDT':
                parameters['mode'] = 'query'
                # print 'What2'
                # print('-- run np search for target --')

                # search target in question question #
            else:
                pass
                #print('-- run np search for target -- --- no question type ---')
        else:
            pass

    elif (mytree[0].label()=='S' and mytree[0][0].label()=='VP') or mytree[0].label()=='SQ':
        if mytree[0].label()!='SQ':
            if mytree[0][0][0].label() == 'VB' and mytree[0][0][0] in ['list','table']:
                parameters['view'] = ['table']
        # print('-- run np search for target -- --- no question type ---')

    elif mytree[0].label()=='NP':
        pass
        # print('-- run np search for target -- --- no question type ---')
        # search target #
    else:
        pass
        # print mytree
        # search target #

    # match target if it is not yet matched
    # rule: first np - last matching nn
    if not target[0]:
        st = get_first_np(mytree)
        if not st: return None # No meaning sentense was found!
        st = st.flatten()
        for i in range(len(st)):
            target = match_param(st[-i-1])
            if target[0]:
                break

    # parse dependancies, add special cases
    if target[0]:
        target_boundaries = [(m.start(), m.end()) 
                                 for m in re.finditer(target[0], original_text)][0]
        target_id = find_token_id(target_boundaries, tokens)

        target_token = tokens[target_id][0]

        target_deps = [d for d in deps 
                           if d[u'dependentGloss'].lower() == target_token.lower() 
                               or 
                               d[u'governorGloss'].lower() == target_token.lower()]

        for dep in target_deps:
            if dep['dep'] == u'amod' and dep[u'dependentGloss'].lower() in ['average','mean']:
                parameters['aggregation'] = 'average'
            if dep['dep'] == u'amod' and dep[u'dependentGloss'].lower() in ['total','summary','overall','many']:
                parameters['aggregation'] = 'count/sum'
            if dep['dep'] == u'amod' and dep[u'dependentGloss'].lower() in ['max', 'maximum']:
                parameters['aggregation'] = 'max'
            if dep['dep'] == u'amod' and dep[u'dependentGloss'].lower() in ['min', 'minimum']:
                parameters['aggregation'] = 'min'

            if dep[u'governorGloss'].lower() in ['distribution','distributed']:
                parameters['hist'] = 'distribution'
            if dep[u'dependentGloss'].lower() in ['distribution','distributed']:
                parameters['hist'] = 'distribution'
            if dep['dep'] == u'nummod':
                parameters['limit'] = dep[u'dependentGloss']
    if 'percent' in original_text.lower():
        parameters['aggregation'] = 'percentage'


    # find group-by parameter
    group_by = []
    address = find_group(mytree)
    if address:
        group_st = mytree[address[:-1]]
        group_st = get_first_np(group_st)
        group_st = ' '.join(group_st.flatten())
        group_by = match_filter(group_st)
        group_by = group_by[0][0]

    # match filter parametes in original text
    filter_by = match_filter(original_text)

    filter_by = [( tmp[0], original_text[tmp[1]:tmp[2]] ) 
                     for tmp in filter_by 
                     if tmp[0] not in group_by]

    filter_by = [tmp for tmp in filter_by 
                     if tmp[0] not in [target[1], 'customer']]

    matched_cats = []
    filter_by_val = {}
    if len(filter_by):
        tokens_vals = [t[0] for t in tokens]

        for filteri in filter_by:
            if filteri[0] not in filter_by_val:
                filter_by_val[filteri[0]] = {'original':filteri[1]}
                filter_by_val[filteri[0]]['cats'] = []

            filteri_boundaries = [(m.start(), m.end()) for m in re.finditer(filteri[1], original_text)][0]
            filteri_id = find_token_id(filteri_boundaries, tokens)
            print filteri_id

            # replace this cycle with search through dependancies
            for iter_i in range(min(filteri_id,2)+1):
                string = ' '.join( tokens_vals[ filteri_id-iter_i : filteri_id+1 ] )

                if 'categories' in filter_kw[filteri[0]]:
                    matched_cats_i = match_categories(string, filter_kw[filteri[0]]['categories'])
                else:
                    matched_cats_i = match_categories(string, filter_kw[filteri[0]]['condition_kw'])
                if matched_cats_i:
                    filter_by_val[filteri[0]]['cats'] += matched_cats_i
            filter_by_val[filteri[0]]['cats'] = list(set(filter_by_val[filteri[0]]['cats']))

    """
    print 'text:'
    print original_text

    print 'params:'
    print parameters

    print 'target:'
    print target[1]

    print 'filter:'
    print filter_by_val

    print 'group_by'
    print group_by
    """
    
    sql_select = []
    sql_filter = []
    sql_group_by = []
    if target[1]:
        if group_by:
            if filter_kw[group_by]['type'] == 'cat':
                sql_group_by.append(group_by)
                sql_select.append(group_by)
            if filter_kw[group_by]['type'] == 'num':
                if 'sql_group_by' in filter_kw[group_by]:
                    sql_group_by.append(filter_kw[group_by]['sql_group_by'])
                    sql_select.append(filter_kw[group_by]['sql_group_by'])
            
        if 'hist' in parameters:
            sql_select.append('count(*)')
            if 'sql_group_by' in filter_kw[target[1]]:
                sql_group_by.append(filter_kw[target[1]]['sql_group_by'])
                sql_select.append(filter_kw[target[1]]['sql_group_by'])
            else:
                sql_select.append(target[1])
                sql_group_by.append(target[1])
        if filter_kw[target[1]]['type'] == 'special':
            sql_select.append('count(*)')
        if filter_kw[target[1]]['type'] == 'cat':
            if 'sql_group_by' in filter_kw[target[1]]:
                sql_group_by.append(filter_kw[target[1]]['sql_group_by'])
                sql_select.append(filter_kw[target[1]]['sql_group_by'])
            else:
                sql_group_by.append(target[1])
                sql_select.append(target[1])
            sql_select.append('count(*)')
            if not group_by: group_by = target[1]
        elif filter_kw[target[1]]['type'] == 'num':
            if 'aggregation' in parameters:
                if parameters['aggregation'] == 'average':
                    sql_select.append('AVG('+target[1]+')')
                elif parameters['aggregation'] == 'count/sum':
                    sql_select.append('SUM('+target[1]+')')
                elif parameters['aggregation'] == 'max':
                    sql_select.append('MAX('+target[1]+')')
                elif parameters['aggregation'] == 'min':
                    sql_select.append('MIN('+target[1]+')')
            else:
                sql_select.append('AVG('+target[1]+')')
        elif filter_kw[target[1]]['type'] == '':
            # add in future
            pass
        
    for f_name,values in filter_by_val.iteritems():
        if filter_kw[f_name]['type'] == 'cat':
            all_cats = filter_kw[f_name]['categories'].keys()
            values = values['cats']
            if not values:
                if 'default' in filter_kw[f_name]:
                    values = [filter_kw[f_name]['default']]
            left_cats = set(all_cats).difference(values)
            
            if not left_cats:
                if 'sql_group_by' in filter_kw[f_name]:
                    sql_group_by.append(filter_kw[f_name]['sql_group_by'])
                    sql_select.append(filter_kw[f_name]['sql_group_by'])
                else:
                    sql_group_by.append(f_name)
                    sql_select.append(f_name)
                if not group_by: group_by = f_name
            else:
                tmp_condition = f_name+' in (\''+'\',\''.join(values)+'\')'
                sql_filter.append(tmp_condition)

    if 'limit' in parameters:
        sql_limit = "" + parameters['limit']
    else:
        sql_limit = ""
    
    # Remove duplicates and main entity 'customer'
    sql_select = list(set(sql_select)-set(['customer']))
    sql_filter = list(set(sql_filter))
    sql_group_by = list(set(sql_group_by)-set(['customer']))
    print 'SELECT'
    print list(set(sql_select))
    print 'WHERE'
    print list(set(sql_filter))
    print 'GROUP BY'
    print list(set(sql_group_by))
    print 'LIMIT'
    print sql_limit

    #return original_text, parameters, target[1], filter_by_val, group_by
    return {'sql_select': sql_select, 
            'sql_group_by': sql_group_by, 
            'sql_filter': sql_filter, 
            'sql_limit': sql_limit, 
            'target': target[1], 
            'group_by': group_by, 
            'parameters': parameters}



# In[21]:



# ## Question taxonomy
# Our analyses can parse 6 main types of question:
# 1. **SBARQ**
# > Direct question introduced by a wh-word or a wh-phrase. Indirect questions and relative clauses should be bracketed as SBAR, not SBARQ.
# 
#     First subtree structures:
#     1. __WHNP - WP__  
#         Noun questions: (Who?, What?)  
#         _Who_ questions are categorized as modelling commands and data is being processed according to model specific scenario.  
#         _What_ questions will be processed further  
#         <br>
#     2. __WHNP - WHNP - WHADJP__  
#         _How many_ type of question  
#         <br>
#     3. __WHNP - WDT__  
#         _What_ type of question          
#         <br>
# 
# 2. **S-VP** or **SQ**
#     - Simple declarative clause, i.e. one that is not introduced by a (possible empty) subordinating conjunction or a wh-word and that does not exhibit subject-verb inversion.
#     - VP - Vereb Phrase.  
#     - Inverted yes/no question, or main clause of a wh-question, following the wh-phrase in SBARQ.
#     Direct commands, like: _show, display, list_
# 3. **NP**
#     - Noun pharase  
#     Simple statement
# 
# 4. **others**
#     For all other forms there is a set of parsing rules
# 
# _http://web.mit.edu/6.863/www/PennTreebankTags.html_
