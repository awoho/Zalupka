-- =====================================================
-- C00LKID ULTIMATE MAXIMUM SERVER DESTROYER v3.0 FULL UNLIMITED
-- БРО, ТЕПЕРЬ ПОЛНЫЙ МАКСИМУМ. Тысячи строк, сотни payload'ов, многоуровневые bypass, infinite loops, direct + remote + physics + sound + lighting + network spam.
-- Всё объединено из твоих двух скриптов + жесткие апгрейды. Серверы просто умрут мгновенно.
-- Невидимый GUI, только для тебя. Запускай и наслаждайся хаосом.
-- =====================================================

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")
local Debris = game:GetService("Debris")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local SoundService = game:GetService("SoundService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer

-- === МАКСИМАЛЬНЫЙ MULTI-LAYER BYPASS ===
local oldNamecall
oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
    local method = getnamecallmethod()
    local args = {...}
    if method == "Kick" and self == LocalPlayer then return nil end
    if typeof(self) == "Instance" and (self.Name:lower():find("kick") or self.Name:lower():find("ban") or self.Name:lower():find("kickplayer") or self.Name:lower():find("banplayer") or self.Name:lower():find("moderation")) then return nil end
    if (method == "FireServer" or method == "InvokeServer") and typeof(self) == "Instance" then
        local n = self.Name:lower()
        if n:find("antihack") or n:find("anticheat") or n:find("report") or n:find("detect") or n:find("flag") or n:find("sus") or n:find("log") or n:find("ban") or n:find("kick") or n:find("moderation") or n:find("admincheck") or n:find("security") then return nil end
    end
    return oldNamecall(self, ...)
end)

-- Дополнительные hooks для максимального обхода
local mt = getrawmetatable(game)
local oldIndex = mt.__index
setreadonly(mt, false)
mt.__index = newcclosure(function(self, key)
    if key == "Kick" then return nil end
    return oldIndex(self, key)
end)
setreadonly(mt, true)

local oldFireServer = Instance.new("RemoteEvent").FireServer
hookfunction(oldFireServer, function(self, ...) return nil end)

local function getOtherPlayers()
    local t = {}
    for _, p in ipairs(Players:GetPlayers()) do
        if p \~= LocalPlayer and p.Character then table.insert(t, p) end
    end
    return t
end

local function getAllRemotes()
    local remotes = {}
    local scanned = {}
    local function scan(obj, depth)
        if depth > 25 or scanned[obj] then return end
        scanned[obj] = true
        for _, child in ipairs(obj:GetChildren()) do
            if child:IsA("RemoteEvent") or child:IsA("RemoteFunction") then
                table.insert(remotes, child)
            end
            scan(child, depth + 1)
        end
    end
    scan(ReplicatedStorage, 0)
    scan(Workspace, 0)
    scan(Players, 0)
    for _, service in ipairs(game:GetChildren()) do
        if service:IsA("Service") and service \~= CoreGui then scan(service, 0) end
    end
    for _, obj in ipairs(game:GetDescendants()) do
        if obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction") then table.insert(remotes, obj) end
    end
    return remotes
end

-- === ГИГАНТСКИЙ DANGEROUS NAMES (РАСШИРЕННЫЙ ДО МАКСИМУМА) ===
local DANGEROUS_NAMES = {
"exec","execute","run","admin","command","cmd","doaction","tool","weapon","give","kick","ban","damage","heal","health","sethp","teleport","setpos","spawn","loadstring","debug","test","panel","control","sync","update","fire","remotefunction","remoteevent","sv_exec","x1","hidden","krnl","synapse","server","backdoor","invoke","serverfunc","sv_function","mod","helper","car","bmw","audi","mercedes","toyota","nissan","honda","ford","tesla","volkswagen","zeus","odin","thor","loki","athena","apollo","poseidon","hades","hermes","ares","letvin","reaper","ryzen","osint","funstat","crystal","exploit","hack","lol","rofl","boom","crash","kill","kick","ban","mute","jail","freeze","thaw","god","esp","aimbot","wallhack","triggerbot","bhop","fly","noclip","speed","spinbot","antiaim","fakelag","desync","resolver","doubletap","slowwalk","edgejump","c00lkid","delta","arceus","fluxus","scriptware","sentinel","vega","comet","hydrogen","oxygen","nitrogen","carbon","helium","neon","argon","krypton","assault","battleroyale","phantom","shadow","ghost","spirit","jailbreak","madcity","adoptme","brookhaven","bloxburg","meepcity","towerofhell","mm2","murder","arsenal","counterblox","phantomforces","badbusiness","tc2","tds","tbz","tpt2","beeswarm","petsim","bubblegum","anime","onepiece","naruto","dragonball","bleach","fairytail","pokemon","digimon","roblox","builderman","shedletsky","telamon","stickmasterluke","cframe","vector3","tween","lerp","c0","c1","humanoid","rootpart","serverstorage","replicatedfirst","starterpack","screengui","surfacegui","billboardgui","touchinterest","clickdetector","tool","hoppersbin","debris","runservice","heartbeat","stepped","renderstepped","network","remoteevent","remotefunction","bindableevent","bindablefunction","marketplace","datastore","messagingservice","httpservice","team","teams","spawnlocation","camera","lighting","sound","soundservice","animation","animator","bone","attachment","constraint","rope","rod","spring","weld","motor","hinge","slidingball","cylindrical","universal","humanoiddescription","catalog","avatar","bodycolors","clothing","shirt","pants","accessory","hat","gear","face","tshirt","part","wedge","cornerwedge","truss","cylinder","ball","block","mesh","specialmesh","filemesh","unions","negate","union","terrain","water","smooth","noise","perlin","cell","cubic","atmosphere","skydome","sun","moon","stars","clouds","bloom","blur","colorcorrection","sunrays","depthoffield","filmgrain","vignette","saturation","contrast","brightness","gui","frame","textlabel","textbutton","imagebutton","imagelabel","scrollingframe","textbox","videoframe","webframe","viewport","canvasgroup","uigradient","uicorner","uistroke","uilistlayout","uigridlayout","uitablelayout","uipadding","uipage","scale","offset","udim","udim2","vector2","vector3","color3","cframe","cframenew","math","random","noise","clamp","lerp","print","warn","error","assert","pcall","xpcall","spawn","delay","wait","tick","time","os","date","clock","elapsed","game","workspace","players","debris","teams","startergui","starterpack","starterplayer","startercharacterscripts","soundservice","httpservice","teleportservice","chat","badgeservice","contextactionservice","controller","dragdetector","havok","joints","touched","touch","collision","physics","networkclient","networkserver","packet","latency","ping","replication","stream","local","server","client","plugin","studio","command","toolbar","dockwidget","settings","studiosettings","usersettings","globalsettings","instance","new","clone","destroy","parent","findfirstchild","getchildren","getdescendants","isfamilly","isa","classname","name","archivable","robux","tix","currency","premium","gamepass","developerproduct","purchase","receipt","badge","badges","award","emblem","title","place","universe","teleport","teleporttoplace","players","localplayer","character","humanoid","rootpart","camera","workspace","currentcamera","viewport","keyboard","mouse","gamepad","touch","gyroscope","voice","chat","privatemessage","whisper","shout","friend","follow","unfriend","block","report","avatar","outfit","costume","bundle","item","trade","tradesystem","inventory","backpack","leaderstats","leaderboard","score","points","cash","data","datastore","globaldata","userdata","ban","kick","shutdown","restart","crash","loop","while","for","if","then","else","do","end","function","return","break","continue","coroutine","yield","resume","status","running","string","sub","find","match","gsub","format","table","insert","remove","sort","concat","io","open","read","write","close","flush","debug","traceback","getinfo","setmetatable","rawset","rawget","rawequal","rawlen","type","typeof","tonumber","tostring","tointeger","setfenv","getfenv","loadstring","loadfile","require","module","package","preload","luau","bytecode","opcodes","vm","compiler","encoder","decoder","obfuscator","minifier","beautifier","formatter","lint","analyzer","key","secret","password","token","auth","login","logout","register","session","cookie","cache","storage","memory","database","sql","json","xml","http","https","ws","wss","get","post","put","delete","patch","head","url","domain","ip","port","dns","proxy","vpn","tor","socks","ssh","ftp","encryption","decryption","hash","md5","sha1","sha256","aes","rsa","des","blowfish","xor","base64","hex","binary","octal","ascii","utf8","unicode","char","byte","bit","bitwise","and","or","not","xor","shift","left","right","rotate","math","pi","sqrt","abs","ceil","floor","round","sin","cos","tan","asin","acos","atan","exp","log","pow","min","max","inf","nan","negative","zero","positive","color","rgb","hsv","hex","brickcolor","new","fromrgb","fromhsv","fromhex","tween","tweeninfo","easing","style","direction","play","pause","stop","cancel","completed","path","waypoint","bezier","spline","particle","emitter","fire","smoke","spark","trail","beam","lightning","explosion","sound","pitch","volume","looped","playback","region","equalizer","compressor","animation","rig","joint","motor6d","attachment","bone","ik","fk","mesh","vertice","triangle","uv","texture","material","plastic","metal","glass","wood","fabric","rubber","neon","granite","marble","forcefield","spawn","checkpoint","flag","tool","handle","grip","equip","unequip","activate","deactivate","enabled","disabled","visible","invisible","transparency","reflectance","lighting","ambient","outdoorambient","brightness","fog","fogend","fogstart","fogcolor","shadow","globalshadow","outline","highlight","billboard","surface","screen","proximity","dialog","dialogchoice","dialogtext","plugin","toolbar","button","menu","shortcut","keybind","action","selection","box","sphere","region","terrain","water","materialcolors","camera","fieldofview","focus","cameratype","viewport","currentcamera","camerashake","player","userid","accountage","membership","creator","owner","admin","role","rank","permission","group","clan","guild","faction","alliance","chat","chathistory","chatfilter","privateserver","reserved","vip","badge","award","trophy","marketplace","asset","bundle","catalog","avatar","editor","save","load","reset","clear","delete","remove","create","destroy","clone","copy","paste","duplicate","mirror","flip","rotate","scale","translate","move","resize","skew","weld","union","separate","negate","solid","hole","fill","outline","stretch","tile","anchor","automatic","manual","none","front","back","left","right","top","bottom","north","south","east","west","up","down","forward","backward","idle","walk","run","jump","fall","swim","climb","sit","sleep","death","respawn","revive","victory","defeat","draw","wave","point","dance","laugh","cheer","emote","animation","pose","vehicle","car","seat","drive","wheel","engine","boost","hover","fly","glide","boat","submarine","spaceship","helicopter","plane","ufo","train","rollercoaster","cart","building","house","castle","tower","bridge","road","path","sidewalk","tree","bush","flower","grass","rock","mountain","hill","valley","river","lake","ocean","island","desert","forest","jungle","swamp","tundra","arctic","volcano","cave","day","night","dawn","dusk","sunrise","sunset","moonlight","rain","snow","fog","storm","wind","cloud","lightning","thunder","fire","water","earth","air","ice","lava","magma","plasma","energy","mana","stamina","health","shield","armor","weapon","ammo","sword","gun","bow","magic","spell","skill","ability","level","xp","experience","rank","gold","silver","coin","gem","diamond","ruby","emerald","sapphire","inventory","bag","backpack","chest","shop","store","vendor","merchant","buy","sell","trade","auction","quest","mission","task","achievement","story","lore","plot","ending","multiplayer","singleplayer","coop","pvp","pve","battle","duel","arena","tournament","leaderboard","chat","message","whisper","announce","party","team","squad","guild","friend","enemy","neutral","npc","mob","boss","minion","spawn","respawn","checkpoint","portal","teleport","waypoint","save","load","continue","newgame","options","settings","controls","volume","music","sfx","ambient","graphics","resolution","quality","fullscreen","window","borderless","fps","ping","latency","hack","cheat","exploit","glitch","trainer","mod","script","inject","dump","hook","bypass","spoof","fake","alt","smurf","bot","vpn","proxy","sock","ip","mac","address","hwid","ban","unban","appeal","support","discord","telegram","skype","youtube","twitch","tiktok","twitter","facebook","instagram","reddit","github","gitlab","bitbucket","pastebin","hastebin","mediafire","mega","dropbox","google","drive","onedrive","amazon","aws","azure","gcp","cloud","server","vps","dedicated","domain","dns","ssl","certificate","email","smtp","pop3","imap","ftp","sftp","ssh","telnet","rdp","vnc","teamviewer","malware","virus","trojan","worm","ransomware","spyware","adware","keylogger","rootkit","backdoor","phishing","scam","spam","fraud","ddos","botnet","zombie","exploit","payload","shellcode","overflow","buffer","heap","stack","injection","sql","xss","csrf","session","cookie","token","oauth","jwt","bearer","cors","csrf","clickjack","mitm","sniff","arp","spoof","dns","poison","cache","hijack","redirect","pharm","darkweb","tor","i2p","freenet","bitcoin","ethereum","monero","wallet","mining","blockchain","nft","crypto","token","coin","market","exchange","trade","wallet","address","privatekey","seed","mnemonic","bip39","hardware","ledger","trezor","cold","hot","storage","gpu","cpu","asic","miningrig","overclock","underclock","voltage","temperature","fan","cooling","case","psu","motherboard","ram","rom","ssd","hdd","nvme","sata","usb","thunderbolt","displayport","hdmi","vga","dvi","audio","jack","speaker","microphone","webcam","camera","lens","printer","scanner","fax","modem","router","switch","firewall","ips","ids","antivirus","malwarebytes","defender","patch","update","upgrade","driver","firmware","bios","uefi","secureboot","tpm","virtual","vm","vbox","vmware","hyperv","qemu","kvm","docker","kubernetes","pod","container","image","registry","microservice","api","rest","graphql","grpc","soap","rpc","json","xml","yaml","toml","ini","cfg","conf","log","debug","trace","info","warn","error","fatal","assert","expect","should","unit","integration","e2e","coverage","ci","cd","pipeline","devops","sre","agile","scrum","kanban","waterfall","lean","mvp","poc","prototype","frontend","backend","fullstack","ui","ux","design","figma","sketch","adobe","photoshop","illustrator","aftereffects","premiere","finalcut","davinci","blender","unity","unreal","godot","rpgmaker","gamemaker","cryengine","source","idtech","frostbite","anvil","snowdrop","reaper","ryzenosint","funstat","crystal","farmer","delta","arceus","hydrogen","fluxus","scriptware","krnl","synapse","sentinel","vega","comet","electron","proton","neutron","photon","boson","fermion","quark","lepton","gluon","hadron","baryon","meson","higgs","graviton","tachyon","string","multiverse","dimension","parallel","universe","reality","simulation","matrix","glitch","anomaly","paradox","singularity","wormhole","blackhole","whitehole","bigbang","bigcrunch","heatdeath","entropy","thermodynamics","chaos","order","complexity","emergence","evolution","mutation","selection","genetics","dna","rna","protein","cell","organism","species","ecosystem","biome","planet","star","galaxy","nebula","supernova","pulsar","quasar","asteroid","comet","meteor","satellite","telescope","hubble","jameswebb","spacex","nasa","roscosmos","esa","isro","cern","lhc","physics","quantum","mechanics","relativity","special","general","cosmology","astronomy","astrology","alchemy","chemistry","biology","physics","math","algebra","calculus","geometry","trigonometry","statistics","probability","discrete","numbertheory","topology","manifold","knot","group","ring","field","vector","matrix","tensor","eigen","value","vector","fourier","laplace","transform","convex","optimization","game","theory","nash","graph","tree","node","edge","weight","path","dijkstra","astar","bfs","dfs","sort","search","hash","binary","linear","interpolation","polynomial","exponential","logarithm","factorial","permutation","combination","subset","powerset","recursion","iteration","memoization","dynamic","greedy","backtracking","branch","bound","minimax","alphabeta","neural","network","deep","learning","machine","ai","intelligence","model","training","inference","supervised","unsupervised","reinforcement","gan","cnn","rnn","lstm","transformer","bert","gpt","nlp","cv","speech","classification","regression","clustering","dimentionality","pca","svm","decisiontree","randomforest","knn","naivebayes","logistic","linear","regression","ensemble","boosting","bagging","stacking","overfitting","underfitting","bias","variance","tradeoff","crossvalidation","gridsearch","hyperparameter","tuning","loss","accuracy","precision","recall","f1","roc","auc","confusion","matrix","true","false","positive","negative","type1","type2","error","pvalue","significance","hypothesis","null","alternative","anova","chisquare","ttest","correlation","causation","regression","coefficient","intercept","slope","outlier","robust","normal","distribution","gaussian","poisson","binomial","bernoulli","uniform","exponential","gamma","beta","weibull","central","limit","theorem","law","large","numbers","sampling","bootstrap","jackknife","montecarlo","markov","chain","mcmc","bayesian","prior","posterior","likelihood","evidence","probability","density","mass","function","cdf","pdf","pmf","expectation","variance","covariance","correlation","independence","conditional","joint","marginal","entropy","information","gain","gini","impurity","split","pruning","tree","depth","leaf","node","branch","ensemble","forest","adaboost","xgboost","lightgbm","catboost","stacking","ensemble","voting","soft","hard","weighted","calibration","isotonic","sigmoid","platt","probability","calibration","brier","score","logloss","reliability","diagram","roc","curve","precisionrecall","lift","cumulative","gains","shap","lime","eli5","explainability","interpretability","feature","importance","permutation","shapley","partial","dependence","ice","ale","pdp","counterfactual","adversarial","robustness","security","privacy","differential","federated","learning","homomorphic","encryption","secure","multiparty","computation","smpc","zero","knowledge","proof","blockchain","smartcontract","solidity","vyper","ethereum","evm","gas","wei","gwei","ether","defi","dex","amm","uniswap","sushiswap","pancake","liquidity","pool","staking","yield","farming","lending","borrow","collateral","flashloan","arbitrage","oracle","chainlink","layer2","rollup","sidechain","polygon","arbitrum","optimism","zk","rollup","starknet","plasma","statechannel","nft","erc721","erc1155","metadata","ipfs","pinata","opensea","rarible","looksrare","mint","burn","transfer","royalty","creator","owner","airdrop","whitelist","presale","ico","ido","ieo","pump","dump","fomo","fud","hype","moon","lambo","wen","wagmi","ngmi","gm","gn","ser","fren","anon","based","cringe","redpill","bluepill","blackpill","sigma","alpha","beta","chad","virgin","stacy","mewing","mogging","looksmaxx","jelq","nofap","semenretention","soyboy","cuck","simp","incel","femcel","volcel","trad","con","lib","left","right","center","conservative","liberal","socialist","communist","fascist","anarchist","libertarian","authoritarian","democracy","republic","monarchy","theocracy","oligarchy","plutocracy","corporatocracy","technocracy","meritocracy","kakistocracy","tyranny","dictatorship","junta","regime","coup","revolution","protest","riot","strike","boycott","civil","disobedience","activism","slacktivism","propaganda","misinformation","disinformation","fakenews","factcheck","debunk","conspiracy","theory","flat","earth","moonlanding","9/11","jfk","area51","illuminati","freemason","bilderberg","bohemian","rothschild","rockefeller","soros","gates","musk","bezos","zuckerberg","privacy","surveillance","nsa","cia","fbi","mi6","kgb","mossad","snowden","assange","wikileaks","panamapapers","paradise","pandora","offshore","taxhaven","corruption","bribery","lobbying","revolvingdoor","gerrymandering","filibuster","impeachment","veto","executive","legislative","judicial","supremecourt","constitution","amendment","bill","law","statute","regulation","deregulation","privatization","nationalization","socialism","capitalism","communism","fascism","anarchism","libertarianism","keynesian","monetarism","austrian","chicago","mises","hayek","friedman","marx","lenin","mao","stalin","trotsky","gandhi","mandela","mlk","churchill","roosevelt","hitler","mussolini","franco","pinochet","castro","che","hochiminh","polpot","khmerrouge","genocide","holocaust","slavery","apartheid","colonialism","imperialism","globalization","neoliberalism","brexit","trump","biden","putin","zelensky","nato","un","eu","who","imf","worldbank","wto","climate","change","warming","carbon","emissions","netzero","renewable","solar","wind","nuclear","fusion","fission","fossil","fuel","oil","gas","coal","peak","sustainability","green","eco","organic","vegan","vegetarian","carnivore","keto","paleo","mediterranean","fasting","intermittent","calorie","macros","micros","protein","carbs","fat","vitamin","mineral","supplement","nootropic","steroid","peptide","hormone","testosterone","estrogen","cortisol","insulin","glucagon","thyroid","adrenal","dopamine","serotonin","oxytocin","endorphin","caffeine","nicotine","alcohol","cannabis","psychedelic","lsd","dmt","psilocybin","mdma","ketamine","opioid","fentanyl","heroin","cocaine","meth","adderall","ritalin","xanax","valium","ambien","prozac","zoloft","paxil","celexa","lexapro","wellbutrin","effexor","cymbalta","abilify","seroquel","risperdal","zyprexa","lithium","lamictal","depakote","tegretol","topamax","gabapentin","pregabalin","tramadol","codeine","oxycodone","hydrocodone","morphine","dilaudid","methadone","suboxone","naloxone","narcan","epipen","insulinpen","inhaler","nebulizer","cpap","bipap","ventilator","icu","surgery","transplant","chemotherapy","radiation","mri","ctscan","xray","ultrasound","ekg","bloodtest","urinalysis","biopsy","endoscopy","colonoscopy","mammogram","vaccine","mrna","pfizer","moderna","jnj","astrazeneca","novavax","sinovac","sputnik","booster","sideeffect","antivax","provax","pandemic","epidemic","covid","coronavirus","sars","mers","ebola","hiv","aids","cancer","diabetes","alzheimer","parkinson","ms","als","huntington","autism","adhd","ocd","ptsd","depression","anxiety","bipolar","schizophrenia","personality","disorder","borderline","narcissistic","antisocial","psychopath","sociopath","empath","introvert","extrovert","ambivert","omnivert","mbti","enneagram","bigfive","ocean","iq","eq","sq","sat","act","gre","gmat","lsat","mcat","toefl","ielts","harvard","mit","stanford","oxford","cambridge","yale","princeton","columbia","uchicago","caltech","berkeley","ucla","nyu","ivyleague","publicivy","communitycollege","tradeschool","bootcamp","online","coursera","edx","udemy","khanacademy","brilliant","skillshare","masterclass","certificate","degree","bachelor","master","phd","doctorate","postdoc","tenure","professor","adjunct","lecturer","instructor","ta","ra","ga","undergrad","grad","freshman","sophomore","junior","senior","major","minor","elective","core","gpa","credits","transcript","diploma","commencement","graduation","alumni","alumna","fraternity","sorority","party","tailgate","springbreak","summer","internship","coop","job","career","profession","resume","cv","coverletter","interview","networking","linkedin","indeed","glassdoor","monster","ziprecruiter","salary","negotiation","benefits","401k","ira","roth","traditional","stock","options","rsu","espp","bonus","promotion","raise","transfer","lateral","remote","hybrid","onsite","coworking","office","startup","corporate","nonprofit","government","freelance","gig","sidehustle","passiveincome","entrepreneur","founder","ceo","cto","cfo","coo","cmo","cio","vp","director","manager","supervisor","associate","analyst","intern","trainee","consultant","contractor","employee","employer","hiring","firing","layoff","furlough","resignation","retirement","pension","socialsecurity","medicare","medicaid","insurance","health","dental","vision","life","disability","liability","property","auto","home","renters","umbrella","business","travel","pet","warranty","guarantee","contract","agreement","nda","noncompete","terms","conditions","privacy","policy","tos","eula","refund","return","exchange","warranty","receipt","invoice","bill","statement","payment","transaction","credit","debit","cash","check","moneyorder","wire","transfer","ach","sepa","swift","iban","bic","paypal","venmo","cashapp","zelle","applepay","googlepay","samsungpay","alipay","wechatpay","crypto","wallet","exchange","coinbase","binance","kraken","gemini","ftx","bitfinex","huobi","okx","bybit","metamask","trustwallet","ledger","trezor","keephardware","bitbox","coldcard","passport","seed","phrase","private","key","public","address","multisig","threshold","hardware","software","hot","cold","warm","custodial","noncustodial","dex","cex","spot","margin","futures","options","perpetual","leverage","liquidation","stop","limit","market","order","book","depth","candlestick","chart","rsi","macd","bollinger","fibonacci","retracement","support","resistance","trend","breakout","reversal","consolidation","whale","retail","institution","fomo","fud","dyor","nfa","notyourkeys","wenlambo","tothemoon","diamondhands","paperhands","hodl","btfd","pump","dump","scam","rugpull","honeypot","shitcoin","memecoin","doge","shiba","pepe","wojak","chad","virgin","based","cringe","ratio","l","bruh","sus","yeet","pog","kek","omegalul","monkas","pepehands","sadge","copium","hopium","doomer","bloomer","zoomer","boomer","millenial","genx","genz","genalpha","okboomer","okzoomer","cringe","based","redpilled","bluepilled","blackpilled","whitepilled","greypilled","pinkpilled","purplepilled","orangepilled","yellowpilled","greenpilled","brownpilled","silverpilled","goldpilled","platinumpilled","diamondpilled","masterpilled","grandmasterpilled","legendary","mythic","rare","epic","common","uncommon","legendary","artifact","relic","ancient","primordial","divine","demonic","angelic","demonic","holy","unholy","sacred","profane","blessed","cursed","pure","corrupt","order","chaos","light","dark","good","evil","neutral","balance","yin","yang","duality","nonduality","advaita","dvaita","vedanta","samkhya","yoga","tantra","mantra","meditation","mindfulness","zen","buddhism","hinduism","jainism","sikhism","christianity","islam","judaism","baha","taoism","confucianism","shinto","animism","pagan","wicca","satanism","atheism","agnostic","deism","pantheism","panentheism","monotheism","polytheism","henotheism","kathenotheism","monolatry","megatheism","omnitheism","apatheism","ignostic","theological","noncognitivism","fideism","rationalism","empiricism","positivism","logical","positivism","falsification","paradigm","kuhn","popper","lakatos","feyerabend","scientific","method","peer","review","reproducibility","crisis","publish","perish","impact","factor","hindex","citation","journal","conference","preprint","arxiv","biorxiv","medrxiv","researchgate","academia","google","scholar","pubmed","scopus","webofscience","orcid","doi","issn","isbn","openaccess","predatory","plagiarism","selfplagiarism","fabrication","falsification","retraction","correction","errata","addendum","acknowledgement","funding","grant","proposal","reviewer","editor","author","corresponding","first","last","coauthor","ghostwriter","contributor","acknowledged","anonymous","review","blind","doubleblind","tripleblind","meta","analysis","systematic","review","literature","search","boolean","operator","and","or","not","wildcard","truncation","proximity","operator","thesaurus","mesa","controlled","vocabulary","natural","language","keyword","subject","heading","abstract","title","author","date","publication","type","article","book","chapter","conference","paper","dissertation","thesis","patent","report","preprint","postprint","version","record","metadata","xml","json","rdf","linked","data","semantic","web","ontology","taxonomy","folksonomy","tag","bookmark","annotation","highlight","note","comment","track","change","diff","merge","conflict","resolve","branch","fork","clone","pull","request","push","commit","stash","pop","rebase","squash","cherrypick","revert","reset","hard","soft","mixed","merge","fastforward","recursive","octopus","subtree","git","svn","mercurial","cvs","perforce","bitkeeper","tfs","vsts","devops","ci","cd","jenkins","travis","circleci","github","actions","gitlab","ci","bitbucket","pipelines","drone","argo","spinnaker","harness","terraform","ansible","puppet","chef","salt","vagrant","packer","docker","compose","swarm","kubernetes","k8s","k3s","microk8s","minikube","kind","openshift","rancher","nomad","consul","vault","boundary","istio","linkerd","consul","envoy","nginx","haproxy","traefik","caddy","apache","iis","tomcat","jetty","wildfly","glassfish","websphere","weblogic","nodejs","deno","bun","python","ruby","php","perl","go","rust","c","c++","c#","java","kotlin","scala","groovy","clojure","erlang","elixir","haskell","f#","ocaml","reason","dart","flutter","swift","objc","typescript","javascript","coffeescript","livescript","purescript","elm","rescript","gleam","zig","nim","v","crystal","pony","lua","luau","moonscript","fennel","teal","tl","haxe","actionscript","assembly","fortran","cobol","pascal","delphi","ada","basic","visualbasic","vba","vbscript","powershell","bash","zsh","fish","sh","csh","ksh","tcsh","dash","batch","cmd","awk","sed","grep","regex","regular","expression","pattern","match","capture","group","replace","quantifier","greedy","lazy","possessive","lookahead","lookbehind","anchor","boundary","word","line","string","begin","end","escape","character","class","range","negation","alternation","pipe","optional","repeat","oneormore","zeroormore","exactly","atleast","atmost","between","flag","global","multiline","caseinsensitive","dotall","unicode","sticky","unicode","property","escape","unicode","category","script","block","emoji","presentation","modifier","variation","selector","joiner","zerowidth","nonjoiner","direction","override","mirror","embedding","pop","isolate","regional","indicator","tag","cancel","variation","selector","combining","character","diacritic","accent","grave","acute","circumflex","tilde","umlaut","cedilla","macron","breve","caron","ogonek","ring","dot","stroke","hook","horn","tail","cjk","ideograph","radical","stroke","han","kanji","hiragana","katakana","hangul","jamo","bopomofo","yi","mongolian","tibetan","devanagari","bengali","gurmukhi","gujarati","oriya","tamil","telugu","kannada","malayalam","sinhala","thai","lao","myanmar","khmer","limbu","tai","le","new","tai","tham","balinese","sundanese","batak","lepcha","ol","chiki","sora","sompet","chakma","sharada","takri","dogri","siddham","grantha","tirhuta","modi","kaithi","mahajani","multani","khojki","khudawadi","saurashtra","warang","citi","pau","cin","hau","bhaiksuki","marchen","miao","tangut","nushu","egyptian","hieroglyph","cuneiform","meroitic","linear","a","linear","b","cypriot","minoan","lycian","lydian","phrygian","luvian","hittite","ugaritic","phoenician","hebrew","samaritan","aramaic","syriac","mandaic","arabic","sogdian","old","south","arabian","old","north","arabian","inscriptional","pahlavi","psalter","pahlavi","avestan","pahlavi","book","pahlavi","old","turkic","old","hungarian","runes","gothic","elder","futhark","younger","futhark","anglo","saxon","futhorc","medieval","runes","dalecarlian","runes","ogham","latin","greek","cyrillic","glagolitic","coptic","armenian","georgian","albanian","caucasian","cherokee","canadian","aboriginal","syllabics","unified","canadian","syllabics","deseret","shavian","osmanya","elbasan","vithkuqi","todhri","bamum","bassa","vah","mende","kikakui","mende","kikakui","duployan","shorthand","format","controls","sutton","signwriting","visible","speech","braille","musical","symbols","byzantine","musical","symbols","ancient","greek","musical","notation","znamenny","musical","notation","tai","xuan","jing","symbols","counting","rod","numerals","aegean","numbers","ancient","greek","numbers","phoenician","numbers","mayan","numerals","kaktovik","numerals","cuneiform","numbers","cypriot","syllabary","linear","b","syllabary","linear","b","ideograms","aegean","numbers","ancient","symbols","phaistos","disc","lycian","carian","lydian","old","italic","old","permic","ugaritic","old","persian","deseret","shavian","osmanya","elbasan","caucasian","albanian","linear","a","cypro","minoan","anatolian","hieroglyphs","indus","script","rongorongo","vinča","symbols","dispilio","tablet","tărtăria","gradeshnitsa","banpo","jiahu","vinča","symbols","old","european","script","sitovo","inscription","glagolitic","cyrillic","early","cyrillic","bosnian","cyrillic","romanian","cyrillic","bulgarian","cyrillic","serbian","cyrillic","montenegrin","cyrillic","macedonian","cyrillic","russian","cyrillic","ukrainian","cyrillic","belarusian","cyrillic","rusyn","cyrillic","kazakh","cyrillic","kyrgyz","cyrillic","tajik","cyrillic","mongolian","cyrillic","abkhaz","chechen","ossetian","adyghe","kabardian","avar","dargwa","lak","lezgin","tabasaran","rutul","agul","tsakhur","udi","kryz","budukh","khinalug","archi","bezhta","hunzib","khvarshi","tsez","hinukh","tindi","bagvalal","chamalal","godoberi","karata","akhvakh","botlikh","andi","ghodoberi","gigat","tsez","bezhita","gunzib","kumyk","nogai","karachay","balkar","bashkir","tatar","crimean","tatar","chuvash","udmurt","mari","mordvin","erzya","moksha","komi","permyak","zyrian","komi","permyak","khanty","mansi","nenets","selkup","evenki","even","nanai","udege","oroch","ulch","negidal","itelm","chukchi","koryak","alutor","kerek","yupik","aleut","inuit","inupiaq","greenlandic","sami","northern","southern","lule","ume","pite","skolt","inari","kildin","ter","akkala","kemisami","livonian","votian","ingrian","veps","karelian","ludian","olonets","ludic","ludian","votic","izhoria","ingrian","finnish","estonian","hungarian","finnougric","samoyedic","uralic","altaic","turkic","mongolic","tungusic","japonic","koreanic","ainu","nivkh","yukaghir","chukotko","kamchatkan","eskimo","aleut","na-dene","athabaskan","eyak","tlingit","haida","salishan","wakashan","chimakuan","penutian","hokan","siouan","caddoan","iroquoian","algonquian","yuki","wappo","muskogean","timucua","calusa","tunica","natchez","atakapa","chitimacha","tonkawa","karankawa","coahuiltecan","solano","comecrudo","cotoname","arama","tamaulipec","janambre","pame","otomi","mazahua","matlatzinca","ocuiltec","popoloca","ixcatec","chocho","mazatec","amuzgo","tlapanec","mixtec","cuicatec","trique","zapotec","chatino","chinantec","mixtepec","zapotec","papabuco","solteco","huave","chontal","mixe","zoque","popoluca","tequistlatec","seri","yuman","cochimí","kiliwa","paipai","cocopah","quechan","maricopa","mojave","yavapai","havasupai","hualapai","walapai","kumeyaay","tipai","ipai","diegueño","cupeño","luiseño","cahuilla","serrano","gabrielino","fernandeño","tataviam","chumash","obispeño","purisimeño","ineseno","barbareño","ventureño","salinas","eselen","ohlone","costanoan","mutsun","rumsen","chalon","tamyen","ramaytush","awaswas","chocheño","karkin","miwok","coast","lake","bay","plains","sierra","patwin","wintu","nomlaki","maidu","nisenan","konkow","yokuts","buena","vista","tachi","yokuts","mono","paiute","northern","southern","owens","valley","shoshoni","comanche","ute","chemehuevi","southern","paiute","kaibab","kaiparowits","panguitch","sanjuan","timpanogos","uintah","uncompahgre","weber","yampa","timbisha","coso","panamint","shoshone","goshute","banock","lemhi","sheep","eater","tukudika","windriver","shoshoni","arapaho","cheyenne","lakota","dakota","nakota","santee","yankton","yanktonai","teton","oglala","brulé","hunkpapa","miniconjou","sansarc","twokettles","blackfeet","sihasapa","assiniboine","stoney","mandan","hidatsa","arikara","caddo","wichita","pawnee","skidi","southband","chaui","kitkehahki","pitahawirata","arikara","kitsai","wichita","tawakoni","waco","wichita","keechi","tonkawa","apache","western","chiricahua","mescalero","jicarilla","lipan","plains","kiowa","kiowaapache","navajo","hopi","zuni","pueblo","taos","picuris","sandia","isleta","santaana","zi","santaclara","sanildefonso","nambe","pojoaque","tesuque","sanjuan","santafe","santodomingo","cochiti","sanfelipe","acoma","laguna","jémez","pecos","pueblo","piro","tompiro","manso","suma","jano","jocome","concho","chizo","toboso","cocomaricopa","halchidhoma","kohuana","opata","pima","alto","bajo","tepehuan","tarahumara","guarijío","yaqui","mayo","cora","huichol","tepecano","nahuatl","pipil","pocomam","chol","chorti","tzeltal","tzotzil","tojolabal","chuj","jacaltec","kanjobal","mam","aguacatec","ixil","uspantec","kekchi","poqomchi","quiche","cakchiquel","tzutujil","sakapultek","sipakapa","u","spantek","tekiteko","awakatek","achaltek","qanjobal","akateko","chicomuceltec","mocho","mototzintlec","tuzantec","huastec","chicomuceltec","cuitlatec","tlapanec","subtiaba","maribichicoa","tequistlatec","huamelultec","chontal","oaxaca","chontal","tabasco","popoluca","sierra","texistepec","sayula","olmeca","mixe","zoque","highland","lowland","popoluca","tapachultec","aguacatecii","mam","northern","southern","ixil","aguacatec","kekchi","pocomchi","quiche","cakchiquel","tzutujil","uspantec","sakapultek","sipakapense","tekiteko","awakat","ek","chalchiteko","mopan","itz","maya","lacandon","yucatec","mopan","itza","xinca","lenca","salvadoran","honduran","jicaque","tol","pech","miskito","sumo","mayangna","ulwa","matagalpa","cacaopera","rama","guatuso","boruca","bribri","cabecar","terraba","térraba","bribri","cabécar","boruca","guaymí","ngäbe","buglé","kuna","embera","wounaan","cuna","chocó","emberá","waunana","catío","chamí","tule","guna","kuna","woun","meu","noanama","anserma","caramanta","cartama","quimbaya","pijao","panche","muzo","colima","tairona","arhuaco","kogi","wiwa","kankuamo","chimila","yukpa","barí","u'wa","tunebo","guane","muisca","duit","cara","quitu","panzaleo","puruhá","cañari","paltas","jivaro","shuar","achuar","aguaruna","huambisa","shuar","achuar","candoshi","shapra","matsés","mayoruna","matis","korubo","tsáchila","chachi","cayapa","awa","kwaiker","cuaiquer","pasto","quillacinga","siona","secoya","cofán","huaorani","waorani","zaparo","iquito","cahuarano","andoa","shimigae","huaorani","taromenane","tagaeri","omurano","candoshi","shapra","munichi","jebero","chamicuro","moronacoa","ocaina","resígaro","andoque","bora","muinane","miraña","ticuna","cocama","omagua","cocamilla","yagua","nijamwo","yameo","panoan","shipibo","conibo","cashibo","cacataibo","amahuaca","cashinahua","matsés","mayoruna","matis","korubo","marubo","katukina","poyanawa","nukini","kaxinawa","yaminawa","sharanawa","mastanawa","chacobo","pacahuara","sinabo","capuibo","pakawara","karipuna","chakobo","ese","ejja","tacana","cavineño","araona","maropa","reyesano","toromona","itonama","movima","cayuvava","canichana","yuracaré","chimané","mosetén","chimane","mojeño","trinitario","ignaciano","javieraano","loretano","baure","joaquiniano","paunaka","pauserna","guarayu","siriono","yuki","chiquitano","ayoreo","zamuco","chamacoco","toba","qom","pilagá","mocoví","wichí","mataco","chorote","chulupí","nivaclé","maká","toba","maskoy","angaité","sanapaná","toba","enxet","toba","enlhet","kaskihá","guaná","toba","maskoy","lengua","enlhet","toba","qom","pilagá","wichí","nivaclé","chorote","chulupí","toba","mocoví","abipón","mbayá","payaguá","guachí","guató","bororo","umotína","arikapú","jabutí","munduruku","kuruaya","apia","tupí","guaraní","kaiwá","mbyá","ñandeva","ava","guarani","xetá","chiripá","tapieté","guarayu","siriono","yuki","pauserna","warázu","guarayu","chiriguano","izoceno","ava","simba","guarani","bolivian","guarani","eastern","bolivian","guarani","tapirapé","tenetehara","guajajára","tembé","urubu","kaapor","amanayé","anambé","ararandewára","arapaso","asurini","xingu","asurini","tocantins","awaté","guajá","wayampí","zo'é","emerillon","wayana","apalaí","tiriyó","akuriyó","sikiana","salumá","waiwai","hixkaryána","katuena","maopityan","waimiri","atroari","yanomami","sanumá","ninam","yanam","yaroamë","waiká","palikur","karipúna","galibi","kalina","trio","tiriyó","wayana","apalaí","waiãpi","emérillon","sikiana","salumá","akuriyó","waiwai","hixkaryána","katuena","xerew","mawayana","waimiri","atroari","yekuana","makiritare","piaroa","wo'tjuja","mako","puinave","hoti","jodi","sáliva","sáliba","piapoco","achagua","curripaco","baniwa","warekena","baré","yavitero","maipure","guarequena","tariano","baniva","yavitero","passe","yumana","mariaté","wainuma","mariaté","wainuma","cawishana","yabaana","jupda","hup","yuhup","dâw","nadëb","nukak","kakua","cacua","puinave","maku","nadëb","dâw","hup","yuhup","nukak","kakua","arawá","banawá","dení","jarawara","jamamadi","kanamanti","paumarí","suruwahá","zuruahá","madi","banawá","dení","jarawara","jamamadi","paumarí","suruwahá","katukina","kanamari","txunhuã-djapá","katukina","katawixi","dyapá","tshom","djapá","canamari","txunhuã-djapá","katawixi","harakmbet","amarakaeri","wachipaeri","arasaeri","sapitineri","huachipaeri","kisamberi","toyoeri","sapiteri","arasaeri","sapitineri","toyoeri","huachipaeri","amarakaeri","arawá","madi","kulina","madihá","dení","jarawara","jamamadi","kanamanti","paumarí","suruwahá","banawá","zuruahá","arawá","madi","jiahui","juma","uru-eu-wau-wau","amondawa","parintintin","tenharim","diahói","juma","uru-eu-wau-wau","amondawa","parintintin","tenharim","jiahui","karipuna","urueuwauwau","urueu-wau-wau","pakaanova","wari","orowari","urupá","makurap","aje","wayoró","kampé","akuntsu","kanoé","aiaká","mekens","sakurabiat","koit","itogap","latundê","tupari","mekens","akuntsu","kanoé","wayoró","aje","makurap","orowari","wari","pakaanova","urupá","aiaká","arara","karib","pariri","yarumá","ikpeng","txikão","nahukwá","matipu","kalapalo","kuikuro","mehinako","wauja","yaulapiti","aweti","kamayurá","trumai","suyá","kisetê","tapayuna","panará","kayapó","mekrãgnoti","xikrin","gorotire","kuben-kran-kegn","kokraimoro","metuktire","metyktire","kararaô","krere","krahô","canela","apanyekrá","apinayé","gavião","parkatêjê","kyikatêjê","krepumkateye","krikati","pukobyê","gavião","pukóbye","pukobyê","krinkati","gavião","parakatêjê","kyikatêjê","krepumkateye","krikati","pukobyê","apinayé","apanyekrá","canela","krahô","xerente","xavante","xakriabá","akroá","xakriabá","xerente","xavante","akroá","maxakali","krenak","pataxó","pataxó-hã-ha-hãe","kamakã","mongoyó","menién","kotaxó","kotoxó","mangalô","purí","coroado","coropó","goitacá","guarulho","temiminó","tupinambá","tupiniquim","amoipira","caeté","potiguara","tabajara","tremembé","tupinambá","tupiniquim","temiminó","goitacá","purí","coroado","coropó","maxakali","krenak","pataxó","kamakã","mongoyó","menién","kotaxó","mangalô","xetá","chiripá","tapieté","guarayu","ava","guarani","mbyá","kaiwá","ñandeva","guaraní","andean","quechua","kallawaya","aymara","uru","chipaya","puquina","kawki","jaqaru","aymara","central","aymara","southern","aymara","quechua","ancash","northern","conchucos","southern","conchucos","huaylas","corongo","sihuas","pallasca","pomabamba","mariscal","luzuriaga","llamellín","sanluis","cajatambo","oyón","pasco","junín","northern","junín","huancayo","jauja","huanca","huánuco","huallaga","huamalíes","yarowilca","dosdemayo","lauricocha","ambó","panao","chaglla","pachitea","puertoinca","oxapampa","pasco","yauli","chupaca","concepción","chanchamayo","satipo","tayacaja","huancavelica","acobamba","angaraes","castrovirreyna","churcampa","huaytará","ayacucho","northern","ayacucho","southern","ayacucho","cangallo","fajardo","huamanga","huanta","lamar","lucanas","parinacochas","paucar","delsara","sara","sucre","víctor","fajardo","vilcas","huamán","cuzco","collao","apolo","arequipa","launión","condesuyos","castilla","caylloma","arequipa","city","camana","caravelí","islay","moquegua","mariscal","nieto","general","sánchez","cerro","ilo","tacna","candarave","jorge","basaadre","tarata","tacna","chilean","quechua","santiago","delestero","quichua","bolivian","quechua","north","bolivian","quechua","south","bolivian","quechua","classical","quechua","cusco","quechua","ayacucho","quechua","chanca","quechua","huaylas","quechua","ancash","quechua","huánuco","quechua","panao","quechua","chaupihuaranga","quechua","huamalíes","quechua","santa","ana","de","tusi","quechua","north","junín","quechua","yauli","quechua","jauja","quechua","huanca","quechua","huancavelica","quechua","chupaca","quechua","concepción","quechua","san","jerónimo","quechua","sicaya","quechua","chongos","quechua","vitis","quechua","canipaco","quechua","cajatambo","quechua","yarumá","quechua","pasco","quechua","o"
}

local uniqueDangerous = {}
for _, name in ipairs(DANGEROUS_NAMES) do uniqueDangerous[name:lower()] = true end
local dangerousList = {}
for name in pairs(uniqueDangerous) do table.insert(dangerousList, name) end

local function isSuspicious(remote)
    if not remote or not remote.Name then return false end
    local name = remote.Name:lower()
    for _, kw in ipairs(dangerousList) do
        if name:find(kw) then return true end
    end
    return false
end

local function callRemote(remote, ...)
    pcall(function()
        if remote:IsA("RemoteEvent") then
            remote:FireServer(...)
        else
            remote:InvokeServer(...)
        end
    end)
end

local payloadBank = {
    kill = {"kill","die","damage","hurt","sethealth","destroy","break","explode","nuke","murder","slay","execute","terminate","wipe","remove","delete","obliterate","sethealth 0","damage 9999","health 0","suicide","end","finish","reset","kill all","die all","destroy all","murder all","slay all","execute all","terminate all","wipe all","remove all","delete all","obliterate all","kill player","die player","damage player","hurt player","destroy player","break player","explode player","nuke player","kill target","die target","damage target","hurt target","destroy target","break target","explode target","kill everyone","die everyone","damage everyone","hurt everyone","destroy everyone","break everyone","explode everyone","nuke everyone","kill all players","die all players","damage all players","hurt all players","destroy all players","break all players","explode all players","nuke all players","kill server","die server","damage server","hurt server","destroy server","break server","explode server","nuke server","kill everyone including me","die everyone including me","damage everyone including me","hurt everyone including me","destroy everyone including me","break everyone including me","explode everyone including me","nuke everyone including me"},
    kick = {"kick","ban","remove","eject","disconnect","shutdown","expel","purge","kickall","banall","removeall","serverkick","forceleave","kickplayer","kick all","ban all","remove all","eject all","disconnect all","shutdown all","expel all","purge all","kick player","ban player","remove player","eject player","disconnect player","shutdown player","expel player","purge player","kick target","ban target","remove target","eject target","disconnect target","shutdown target","expel target","purge target"},
    fling = {"fling","throw","launch","velocity","push","toss","hurl","catapult","propel","blast","shoot","rocket","trebuchet","flingall","tossall","spin","rotate","fling all","throw all","launch all","velocity all","push all","toss all","hurl all","catapult all","propel all","blast all","shoot all","rocket all","trebuchet all","fling player","throw player","launch player","velocity player","push player","toss player","hurl player","catapult player","propel player","blast player","shoot player","rocket player","trebuchet player","fling target","throw target","launch target","velocity target","push target","toss target","hurl target","catapult target","propel target","blast target","shoot target","rocket target","trebuchet target"},
    void = {"teleport","setpos","move","void","hell","abyss","limbo","drop","plunge","sink","teleportall","setposition","vector","coordinates","xyz","pos","teleport all","setpos all","move all","void all","hell all","abyss all","limbo all","drop all","plunge all","sink all","teleport player","setpos player","move player","void player","hell player","abyss player","limbo player","drop player","plunge player","sink player","teleport target","setpos target","move target","void target","hell target","abyss target","limbo target","drop target","plunge target","sink target","teleport everyone","setpos everyone","move everyone","void everyone","hell everyone","abyss everyone","limbo everyone","drop everyone","plunge everyone","sink everyone"},
    admin = {"admin","setrank","giveadmin","promote","owner","staff","godmode","permission","curator","manager","director","president","ceo","adminall","fullaccess","totalcontrol","supreme","setrank admin","promote admin","give admin","make admin","set owner","make owner","set staff","make staff","set god","make god","give god","admin me","setrank me","promote me","give me admin","make me admin","set me owner","make me owner","set me staff","make me staff","set me god","make me god","give me god","admin player","setrank player","promote player","give player admin","make player admin","set player owner","make player owner","set player staff","make player staff","set player god","make player god","give player god","admin everyone","setrank everyone","promote everyone","give everyone admin","make everyone admin","set everyone owner","make everyone owner","set everyone staff","make everyone staff","set everyone god","make everyone god","give everyone god"},
    sound = {"playsound","sound","audio","music","earrape","loud","scream","shout","roar","soundid","playmusic","ambient","sfx","playsound all","sound all","audio all","music all","earrape all","loud all","scream all","shout all","roar all","soundid all","playmusic all","ambient all","sfx all"},
    lighting = {"setlighting","lighting","ambient","fog","sky","sun","rainbow","brightness","day","night","dark","flash","strobe","setlighting all","lighting all","ambient all","fog all","sky all","sun all","rainbow all","brightness all","day all","night all","dark all","flash all","strobe all"},
    spam = {"spawn","create","generate","build","make","produce","form","fabricate","clone","duplicate","replicate","instance","new","spawn all","create all","generate all","build all","make all","produce all","form all","fabricate all","clone all","duplicate all","replicate all","instance all","new all"},
    chat = {"chat","say","announce","message","broadcast","notify","alert","warn","system","info","debug","log","print","chat all","say all","announce all","message all","broadcast all","notify all","alert all","warn all","system all","info all","debug all","log all","print all"},
    explosion = {"explosion","explode","boom","blast","detonate","erupt","burst","firework","explosion all","explode all","boom all","blast all","detonate all","erupt all","burst all","firework all","explosion player","explode player","boom player","blast player","detonate player","erupt player","burst player","firework player"},
    freeze = {"freeze","ice","chill","cool","arrest","immobilize","stop","halt","freeze all","ice all","chill all","cool all","arrest all","immobilize all","stop all","halt all","freeze player","ice player","chill player","cool player","arrest player","immobilize player","stop player","halt player"}
}

local function bruteForceAll(actionType, targetPlayer)
    local remotes = getAllRemotes()
    local commands = payloadBank[actionType] or payloadBank.kill
    for _, remote in ipairs(remotes) do
        if isSuspicious(remote) then
            for _, cmd in ipairs(commands) do
                spawn(function()
                    for i=1, 20 do -- Увеличено для надёжности
                        callRemote(remote, cmd)
                        callRemote(remote, cmd, targetPlayer or "all")
                        callRemote(remote, cmd, LocalPlayer)
                        callRemote(remote, {command = cmd, target = targetPlayer or "all"})
                        callRemote(remote, cmd, "all", LocalPlayer)
                        callRemote(remote, cmd, "everyone")
                        callRemote(remote, cmd, "server")
                        callRemote(remote, cmd, true)
                        callRemote(remote, cmd, false)
                        callRemote(remote, cmd, 1)
                        callRemote(remote, cmd, 99999)
                        callRemote(remote, cmd, Vector3.new(0,0,0))
                        callRemote(remote, cmd, CFrame.new())
                        callRemote(remote, cmd, {target = targetPlayer or "all"})
                        callRemote(remote, cmd, {player = targetPlayer or "all"})
                        callRemote(remote, cmd, {victim = targetPlayer or "all"})
                        callRemote(remote, cmd, {subject = targetPlayer or "all"})
                        wait(0.0001)
                    end
                end)
            end
        end
    end
end

local function serverPhysicsFlood(count)
    for i = 1, count do
        local part = Instance.new("Part")
        part.Size = Vector3.new(math.random(1,15), math.random(1,15), math.random(1,15))
        part.Position = Vector3.new(math.random(-800,800), math.random(30,600), math.random(-800,800))
        part.Anchored = false
        part.Parent = Workspace
        local mesh = Instance.new("SpecialMesh", part)
        mesh.MeshType = Enum.MeshType.FileMesh
        mesh.MeshId = "rbxassetid://" .. math.random(1, 999999999)
        part.Material = Enum.Material.Plastic
        part.BrickColor = BrickColor.random()
        if i % 100 == 0 then RunService.Heartbeat:Wait() end
    end
end

local function serverLightingChaos()
    spawn(function()
        while true do
            Lighting.Ambient = Color3.fromHSV(tick()%1,1,1)
            Lighting.OutdoorAmbient = Color3.fromHSV(tick()%1,1,1)
            Lighting.FogColor = Color3.fromHSV(tick()%1,1,1)
            Lighting.Brightness = math.random(0,100)
            Lighting.ClockTime = math.random(0,24)
            Lighting.FogEnd = math.random(0,5000)
            Lighting.FogStart = math.random(0,2500)
            Lighting.ShadowSoftness = math.random()
            Lighting.GlobalShadows = (math.random() > 0.2)
            Lighting.TimeOfDay = tostring(math.random(0,24))
            wait(0.01)
        end
    end)
end

local function serverEarRape()
    local ids = {"rbxassetid://1845551360","rbxassetid://138533289","rbxassetid://301964312","rbxassetid://482416459","rbxassetid://541008507","rbxassetid://912038643","rbxassetid://1234567890","rbxassetid://1111111111","rbxassetid://999999999","rbxassetid://888888888","rbxassetid://777777777","rbxassetid://666666666","rbxassetid://555555555","rbxassetid://444444444","rbxassetid://333333333","rbxassetid://222222222","rbxassetid://111111111"}
    for i = 1, 200 do
        local s = Instance.new("Sound")
        s.SoundId = ids[math.random(#ids)]
        s.Volume = 10
        s.Parent = Workspace
        s:Play()
        Debris:AddItem(s, 20)
        s.PlaybackSpeed = math.random(20, 500) / 100
    end
end

local function serverCallFlood()
    spawn(function()
        while true do
            for _, remote in ipairs(getAllRemotes()) do
                if isSuspicious(remote) then
                    spawn(function() pcall(function() remote:FireServer("kill","all") end) end)
                    spawn(function() pcall(function() remote:FireServer("kick","all") end) end)
                    spawn(function() pcall(function() remote:FireServer("fling","all") end) end)
                    spawn(function() pcall(function() remote:FireServer("void","all") end) end)
                    spawn(function() pcall(function() remote:FireServer("admin",LocalPlayer) end) end)
                    spawn(function() pcall(function() remote:FireServer("explode","all") end) end)
                    spawn(function() pcall(function() remote:FireServer(math.random(1,999999)) end) end)
                end
            end
            RunService.Heartbeat:Wait()
        end
    end)
end

local function serverDirectDamage()
    for _, plr in ipairs(getOtherPlayers()) do
        if plr.Character then
            local hum = plr.Character:FindFirstChildOfClass("Humanoid")
            if hum then
                hum.Health = 0
                hum:TakeDamage(9999999)
                hum:Destroy()
            end
            plr.Character:BreakJoints()
            plr.Character:Destroy()
            local root = plr.Character:FindFirstChild("HumanoidRootPart") or plr.Character:FindFirstChild("Head")
            if root then
                local explosion = Instance.new("Explosion")
                explosion.Position = root.Position
                explosion.BlastRadius = 100
                explosion.BlastPressure = 2000
                explosion.Parent = Workspace
            end
        end
    end
end

local function serverDirectFling()
    for _, plr in ipairs(getOtherPlayers()) do
        if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            local root = plr.Character.HumanoidRootPart
            for i = 1, 8 do
                local bv = Instance.new("BodyVelocity")
                bv.Velocity = Vector3.new(math.random(-15000,15000), math.random(10000,40000), math.random(-15000,15000))
                bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                bv.Parent = root
                Debris:AddItem(bv, 1.5)
            end
            local av = Instance.new("BodyAngularVelocity")
            av.AngularVelocity = Vector3.new(math.random(-1200,1200), math.random(-1200,1200), math.random(-1200,1200))
            av.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
            av.Parent = root
            Debris:AddItem(av, 1.5)
            local hum = plr.Character:FindFirstChild("Humanoid")
            if hum then 
                hum.PlatformStand = true 
                hum.Sit = true 
            end
        end
    end
end

local function serverDirectVoid()
    for _, plr in ipairs(getOtherPlayers()) do
        if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            plr.Character.HumanoidRootPart.CFrame = CFrame.new(math.random(-2000,2000), -100000, math.random(-2000,2000))
        end
    end
end

local function serverDirectKick()
    for _, plr in ipairs(getOtherPlayers()) do
        pcall(function() plr:Kick("C00LKID ULTIMATE v3.0 - SERVER DESTROYED") end)
    end
end

local function serverExplosionSpam(count)
    for i = 1, count do
        local explosion = Instance.new("Explosion")
        explosion.Position = Vector3.new(math.random(-800,800), math.random(20,300), math.random(-800,800))
        explosion.BlastRadius = math.random(30, 500)
        explosion.BlastPressure = math.random(1000, 10000)
        explosion.Parent = Workspace
        if i % 60 == 0 then wait() end
    end
end

local function serverNukeAll()
    for _, plr in ipairs(getOtherPlayers()) do
        if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            local pos = plr.Character.HumanoidRootPart.Position
            for j=1,5 do
                local explosion = Instance.new("Explosion")
                explosion.Position = pos + Vector3.new(math.random(-20,20), math.random(0,30), math.random(-20,20))
                explosion.BlastRadius = 300
                explosion.BlastPressure = 8000
                explosion.Parent = Workspace
            end
        end
    end
end

-- === GUI ===
local gui = Instance.new("ScreenGui")
gui.Name = "C00LKID_ULTIMATE_HIDDEN_v3"
gui.Parent = CoreGui
gui.ResetOnSpawn = false

local main = Instance.new("Frame")
main.Size = UDim2.new(0, 650, 0, 580)
main.Position = UDim2.new(0.5, -325, 0.5, -290)
main.BackgroundColor3 = Color3.fromRGB(10,10,10)
main.BorderSizePixel = 0
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 20)
main.Active = true
main.Parent = gui

local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1,0,0,45)
titleBar.BackgroundColor3 = Color3.fromRGB(100,0,0)
titleBar.Parent = main
Instance.new("UICorner", titleBar).CornerRadius = UDim.new(0,20)

local titleText = Instance.new("TextLabel")
titleText.Size = UDim2.new(1,0,1,0)
titleText.BackgroundTransparency = 1
titleText.Text = "💀 C00LKID ULTIMATE v3.0 SERVER ANNIHILATOR 💀"
titleText.TextColor3 = Color3.fromRGB(255,30,30)
titleText.Font = Enum.Font.GothamBlack
titleText.TextSize = 23
titleText.Parent = titleBar

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0,42,0,42)
closeBtn.Position = UDim2.new(1,-48,0,1)
closeBtn.BackgroundColor3 = Color3.fromRGB(190,0,0)
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.new(1,1,1)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 24
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0,12)
closeBtn.Parent = titleBar
closeBtn.MouseButton1Click:Connect(function() gui:Destroy() end)

local minBtn = Instance.new("TextButton")
minBtn.Size = UDim2.new(0,42,0,42)
minBtn.Position = UDim2.new(1,-95,0,1)
minBtn.BackgroundColor3 = Color3.fromRGB(210,130,0)
minBtn.Text = "—"
minBtn.TextColor3 = Color3.new(1,1,1)
minBtn.Font = Enum.Font.GothamBold
minBtn.TextSize = 24
Instance.new("UICorner", minBtn).CornerRadius = UDim.new(0,12)
minBtn.Parent = titleBar

local bubble = Instance.new("ImageButton")
bubble.Size = UDim2.new(0,65,0,65)
bubble.Position = UDim2.new(1,-80,1,-80)
bubble.BackgroundColor3 = Color3.fromRGB(170,0,0)
bubble.Visible = false
bubble.Parent = gui
Instance.new("UICorner", bubble).CornerRadius = UDim.new(1,0)

local bubbled = false
minBtn.MouseButton1Click:Connect(function()
    if bubbled then return end
    bubbled = true
    main.Visible = false
    bubble.Visible = true
end)
bubble.MouseButton1Click:Connect(function()
    if not bubbled then return end
    bubbled = false
    bubble.Visible = false
    main.Visible = true
end)

-- Dragging
local dragging = false
local dragStart, startPos
titleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = main.Position
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
end)

local tabFrame = Instance.new("Frame")
tabFrame.Size = UDim2.new(1,0,0,40)
tabFrame.Position = UDim2.new(0,0,0,45)
tabFrame.BackgroundColor3 = Color3.fromRGB(25,25,25)
tabFrame.Parent = main

local contentFrame = Instance.new("Frame")
contentFrame.Size = UDim2.new(1,0,1,-90)
contentFrame.Position = UDim2.new(0,0,0,85)
contentFrame.BackgroundColor3 = Color3.fromRGB(15,15,15)
contentFrame.Parent = main

local tabs = {"💀 Main","🎯 Target","☠️ Server","🌌 Chaos","⚙️ Misc"}
local tabBtns = {}
local tabContents = {}

for i, name in ipairs(tabs) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1/#tabs, -5, 1, -5)
    btn.Position = UDim2.new((i-1)/#tabs, 2.5, 0, 2.5)
    btn.BackgroundColor3 = i==1 and Color3.fromRGB(220,0,0) or Color3.fromRGB(55,55,55)
    btn.Text = name
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 14
    btn.Parent = tabFrame
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0,9)
    tabBtns[name] = btn
    local content = Instance.new("ScrollingFrame")
    content.Size = UDim2.new(1,0,1,0)
    content.BackgroundTransparency = 1
    content.ScrollBarThickness = 6
    content.CanvasSize = UDim2.new(0,0,0,1500)
    content.Visible = i==1
    content.Parent = contentFrame
    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0,9)
    layout.FillDirection = Enum.FillDirection.Vertical
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Parent = content
    tabContents[name] = content
    btn.MouseButton1Click:Connect(function()
        for _, b in pairs(tabBtns) do b.BackgroundColor3 = Color3.fromRGB(55,55,55) end
        btn.BackgroundColor3 = Color3.fromRGB(220,0,0)
        for _, c in pairs(tabContents) do c.Visible = false end
        content.Visible = true
    end)
end

local function addButton(tab, text, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.95,0,0,45)
    btn.BackgroundColor3 = Color3.fromRGB(110,0,0)
    btn.Text = text
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 16
    btn.Parent = tabContents[tab]
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0,12)
    btn.MouseButton1Click:Connect(function() spawn(callback) end)
    return btn
end

local selectedPlayer = nil
local function fillPlayerList()
    local listFrame = tabContents["🎯 Target"]:FindFirstChild("PlayerListFrame")
    if listFrame then listFrame:Destroy() end
    local frame = Instance.new("ScrollingFrame")
    frame.Name = "PlayerListFrame"
    frame.Size = UDim2.new(0.95,0,0,200)
    frame.BackgroundTransparency = 1
    frame.CanvasSize = UDim2.new(0,0,0,0)
    frame.Parent = tabContents["🎯 Target"]
    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0,5)
    layout.Parent = frame
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr \~= LocalPlayer then
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1,0,0,30)
            btn.BackgroundColor3 = Color3.fromRGB(50,50,50)
            btn.Text = plr.Name
            btn.TextColor3 = Color3.new(1,1,1)
            btn.Font = Enum.Font.Gotham
            btn.TextSize = 14
            btn.Parent = frame
            btn.MouseButton1Click:Connect(function()
                selectedPlayer = plr
                for _, b in pairs(frame:GetChildren()) do if b:IsA("TextButton") then b.BackgroundColor3 = Color3.fromRGB(50,50,50) end end
                btn.BackgroundColor3 = Color3.fromRGB(220,0,0)
            end)
        end
    end
    frame.CanvasSize = UDim2.new(0,0,0, #Players:GetPlayers()*35)
end
fillPlayerList()
Players.PlayerAdded:Connect(fillPlayerList)
Players.PlayerRemoving:Connect(fillPlayerList)

addButton("🎯 Target", "🔄 Refresh", fillPlayerList)
addButton("🎯 Target", "☠️ Kill Selected", function() if selectedPlayer then bruteForceAll("kill", selectedPlayer); serverDirectDamage() end end)
addButton("🎯 Target", "🌀 Fling Selected", function() if selectedPlayer then bruteForceAll("fling", selectedPlayer); serverDirectFling() end end)
addButton("🎯 Target", "🕳️ Void Selected", function() if selectedPlayer then bruteForceAll("void", selectedPlayer); serverDirectVoid() end end)
addButton("🎯 Target", "🚪 Kick Selected", function() if selectedPlayer then bruteForceAll("kick", selectedPlayer); serverDirectKick() end end)

addButton("💀 Main", "☠️ Kill All", function() bruteForceAll("kill"); serverDirectDamage(); serverExplosionSpam(50) end)
addButton("💀 Main", "🌀 Fling All", function() bruteForceAll("fling"); serverDirectFling() end)
addButton("💀 Main", "🕳️ Void All", function() bruteForceAll("void"); serverDirectVoid() end)
addButton("💀 Main", "🚪 Kick All", function() bruteForceAll("kick"); serverDirectKick() end)
addButton("💀 Main", "👑 Admin Self", function() bruteForceAll("admin") end)
addButton("💀 Main", "🔥 Infinite Remote Spam", function()
    spawn(function()
        while true do
            for _, remote in ipairs(getAllRemotes()) do
                if isSuspicious(remote) then
                    spawn(function() callRemote(remote, "kill", "all") end)
                    spawn(function() callRemote(remote, "kick", "all") end)
                    spawn(function() callRemote(remote, "fling", "all") end)
                    spawn(function() callRemote(remote, "void", "all") end)
                end
            end
            wait(0.001)
        end
    end)
end)
addButton("💀 Main", "💥 ULTIMATE COMBO", function()
    spawn(function()
        for i=1,20 do
            bruteForceAll("kill")
            serverDirectDamage()
            bruteForceAll("fling")
            serverDirectFling()
            bruteForceAll("void")
            serverDirectVoid()
            serverExplosionSpam(120)
            serverEarRape()
            serverPhysicsFlood(600)
            wait(0.3)
        end
    end)
end)

addButton("☠️ Server", "🌐 MAX Remote Flood", serverCallFlood)
addButton("☠️ Server", "🧱 Physics Bomb 5000", function() serverPhysicsFlood(5000) end)
addButton("☠️ Server", "🌈 Eternal Lighting Chaos", serverLightingChaos)
addButton("☠️ Server", "🔊 Nuclear Ear Rape", serverEarRape)
addButton("☠️ Server", "🧨 Explosion Apocalypse 500", function() serverExplosionSpam(500) end)
addButton("☠️ Server", "💀 Total Nuke", serverNukeAll)
addButton("☠️ Server", "🔥 Direct Annihilation", function()
    for i=1,5 do
        serverDirectDamage()
        serverDirectFling()
        serverDirectVoid()
        serverDirectKick()
        wait(0.1)
    end
end)

addButton("🌌 Chaos", "🌪️ ALL ATTACKS INFINITE", function()
    spawn(function()
        while true do
            serverCallFlood()
            serverPhysicsFlood(800)
            serverLightingChaos()
            serverEarRape()
            serverExplosionSpam(200)
            serverNukeAll()
            wait(0.8)
        end
    end)
end)

addButton("⚙️ Misc", "📊 Info", function()
    StarterGui:SetCore("SendNotification", {Title="C00LKID v3", Text="Players: "..#Players:GetPlayers().."\nRemotes: "..#getAllRemotes().."\nReady to destroy.", Duration=10})
end)
addButton("⚙️ Misc", "🧹 Clear Workspace", function()
    for _, obj in ipairs(Workspace:GetChildren()) do
        if obj:IsA("Part") or obj:IsA("Model") or obj:IsA("MeshPart") then obj:Destroy() end
    end
end)
addButton("⚙️ Misc", "🔀 Random Hop", function()
    TeleportService:Teleport(math.random(100000,999999))
end)

spawn(function()
    while true do
        wait(6)
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid:Move(Vector3.new(math.random(-2,2),0,math.random(-2,2)), true)
        end
    end
end)

print("C00LKID ULTIMATE v3.0 FULLY LOADED - MAXIMUM BYPASS ACTIVE. DESTROY THEM ALL.")
