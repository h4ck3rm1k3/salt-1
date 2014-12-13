# -*- coding: utf-8 -*-
'''
Run Chef recipes

@author: Thibault BRONCHAIN
(c) 2014 - MadeiraCloud
'''


# Result object template
def _result(name="",changes={},result=False,comment="",stdout=''):
    return {'name': name,
            'changes': changes,
            'result': result,
            'comment': comment,
            'state_stdout': stdout}
# Valid result object
def _valid(name="",changes={},comment="",stdout=''):
    return _result(name=name,changes=changes,result=True,comment=comment,stdout=stdout)
# Invalid result object
def _invalid(name="",changes={},comment="",stdout=''):
    return _result(name=name,changes=changes,result=False,comment=comment,stdout=stdout)


# Run client node
def client(server, client_key=None, config=None, arguments=[]):
    ags = {}
    if not server:
        return _invalid(comment="No server specified.")
    if client_key:
        ags["client_key"] = client_key
    if config:
        ags["config"] = config
    for a in arguments:
        if ("key" not in a) or ("value" not in a): continue
        ags[a["key"]] = a["value"]
    ag = ["%s=%s"%(a,ags[a]) for a in ags]
    try:
        ret = __salt__['chef.client'](*ag)
    except Exception as e:
        comment = "Error running chef client: %s.\n"%e
        return _invalid(comment=comment)
    else:
        out = "%s\n%s"%(ret["stdout"],ret["stderr"])
        if ret.get("retcode"):
            comment = "Client ran with error(s) (code %s).\n"%(ret["retcode"])
            return _invalid(comment=comment,
                            stdout=out)
        else:
            comment = "Client ran without error.\n"
            return _valid(comment=comment,
                          stdout=out)

# Run solo node
def solo(config=None, recipe_url=None, arguments=[]):
    ags = {}
    if config:
        ags["config"] = config
    if recipe_url:
        ags["recipe-url"] = recipe_url
    for a in arguments:
        if ("key" not in a) or ("value" not in a): continue
        ags[a["key"]] = a["value"]
    ag = ["%s=%s"%(a,ags[a]) for a in ags]
    try:
        ret = __salt__['chef.solo'](*ag)
    except Exception as e:
        comment = "Error running chef solo: %s\n"%e
        return _invalid(comment=comment)
    else:
        out = "%s\n%s"%(ret["stdout"],ret["stderr"])
        if ret.get("retcode"):
            comment = "Receipe processed with error(s) (code %s).\n"%(ret["retcode"])
            return _invalid(comment=comment,
                            stdout=out)
        else:
            comment = "Recipe processed without error.\n"
            return _valid(comment=comment,
                          stdout=out)
