--[[
    ╔══════════════════════════════════════════╗
    ║     WordMaster Dictionary v3.0           ║
    ║     Built with ReGUI Library             ║
    ║     ImGui SAMP Style                     ║
    ╚══════════════════════════════════════════╝
]]

-- ═══════════════════════════════════════════
-- ЗАВАНТАЖЕННЯ ReGUI БІБЛІОТЕКИ
-- ═══════════════════════════════════════════

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/x2Swiftz/UI-Library/main/Libraries/ReGUI.lua"))()

-- ═══════════════════════════════════════════
-- БАЗА АНГЛІЙСЬКИХ СЛІВ (2000+)
-- ═══════════════════════════════════════════

local AllWords = {
    -- A words (200+)
    "abandon","ability","able","about","above","abroad","absence","absent","absolute","absolutely",
    "absorb","abstract","absurd","abuse","academic","academy","accept","acceptable","access","accessible",
    "accident","accidental","accommodate","accompany","accomplish","accord","accordance","according","account","accountant",
    "accumulate","accuracy","accurate","accusation","accuse","achieve","achievement","acid","acknowledge","acquire",
    "acquisition","acre","across","act","action","activate","active","activist","activity","actor",
    "actress","actual","actually","adapt","adaptation","add","addition","additional","address","adequate",
    "adjust","adjustment","administration","administrator","admire","admission","admit","adolescent","adopt","adult",
    "advance","advanced","advantage","adventure","advertise","advertisement","advice","advise","adviser","affair",
    "affect","affection","afford","afraid","after","afternoon","again","against","age","aged",
    "agency","agenda","agent","aggressive","ago","agree","agreement","agricultural","agriculture","ahead",
    "aid","aim","air","aircraft","airline","airport","alarm","album","alcohol","alert",
    "alien","alike","alive","all","allegation","allege","alliance","allow","allowance","ally",
    "almost","alone","along","alongside","already","also","alter","alternative","although","altogether",
    "always","amazing","ambition","ambitious","amendment","among","amount","amuse","analysis","analyst",
    "analyze","ancient","anger","angle","angry","animal","ankle","announce","announcement","annual",
    "anonymous","another","answer","anxiety","anxious","any","anybody","anymore","anyone","anything",
    "anyway","anywhere","apart","apartment","apparent","apparently","appeal","appear","appearance","apple",
    "application","apply","appoint","appointment","appreciate","appreciation","approach","appropriate","approval","approve",
    "approximate","area","arena","argue","argument","arise","arm","army","around","arrange",
    "arrangement","arrest","arrival","arrive","arrow","art","article","artificial","artist","artistic",
    "aspect","assault","assembly","assert","assess","assessment","asset","assign","assignment","assist",
    "assistance","assistant","associate","association","assume","assumption","assure","atmosphere","attach","attack",
    "attain","attempt","attend","attendance","attention","attitude","attorney","attract","attraction","attractive",
    "attribute","audience","author","authority","automatic","automatically","autumn","available","avenue","average",
    "avoid","award","aware","awareness","awesome","awful","awkward","axe","axis",

    -- B words (180+)
    "baby","back","background","backward","bacon","bad","badly","bag","bake","balance",
    "ball","ban","band","bank","bar","bare","barely","bargain","barn","barrel",
    "barrier","base","baseball","basic","basically","basis","basket","basketball","bat","bath",
    "bathroom","battery","battle","bay","beach","bean","bear","beard","beat","beautiful",
    "beauty","because","become","bed","bedroom","beef","beer","before","begin","beginning",
    "behavior","behind","being","belief","believe","bell","belong","below","belt","bench",
    "bend","beneath","benefit","beside","besides","best","bet","better","between","beyond",
    "bible","big","bike","bill","billion","bind","biological","biology","bird","birth",
    "birthday","bit","bite","bitter","black","blade","blame","blank","blanket","blast",
    "bleed","blend","bless","blind","block","blood","blow","blue","board","boat",
    "body","bomb","bombing","bond","bone","book","boom","boot","border","born",
    "boss","both","bother","bottle","bottom","bounce","bound","boundary","bowl","box",
    "boy","boyfriend","brain","branch","brand","brave","bread","break","breakfast","breast",
    "breath","breathe","breed","brick","bridge","brief","briefly","bright","brilliant","bring",
    "broad","broadcast","broken","brother","brown","brush","buck","budget","bug","build",
    "builder","building","bullet","bunch","burden","burn","burst","bury","bus","business",
    "busy","butter","button","buy","buyer","butterfly","bypass","byte",

    -- C words (250+)
    "cabin","cabinet","cable","cake","calculate","calendar","call","calm","camera","camp",
    "campaign","campus","can","cancel","cancer","candidate","cap","capable","capacity","capital",
    "captain","capture","car","carbon","card","care","career","careful","carefully","carrier",
    "carry","case","cash","cast","castle","cat","catch","category","cause","ceiling",
    "celebrate","celebration","celebrity","cell","center","central","century","ceremony","certain","certainly",
    "chain","chair","chairman","challenge","chamber","champion","championship","chance","change","channel",
    "chapter","character","characteristic","charge","charity","chart","chase","cheap","check","cheek",
    "cheese","chef","chemical","chest","chicken","chief","child","childhood","chip","chocolate",
    "choice","choose","church","cigarette","circle","circumstance","cite","citizen","city","civil",
    "civilian","claim","class","classic","classroom","clean","clear","clearly","client","climate",
    "climb","clinical","clock","clone","close","closely","closer","closest","cloth","clothes",
    "clothing","cloud","club","clue","cluster","coach","coal","coalition","coast","coat",
    "code","coffee","cognitive","cold","collapse","colleague","collect","collection","collective","college",
    "colonial","colony","color","column","combination","combine","come","comedy","comfort","comfortable",
    "command","commander","comment","commercial","commission","commit","commitment","committee","common","communicate",
    "communication","community","companion","company","compare","comparison","compete","competition","competitive","competitor",
    "complain","complaint","complete","completely","complex","complexity","complicated","component","compose","composition",
    "comprehensive","computer","concentrate","concentration","concept","concern","concerned","concert","conclude","conclusion",
    "concrete","condition","conduct","conference","confidence","confident","confirm","conflict","confront","confusion",
    "congress","connect","connection","consciousness","consensus","consequence","conservative","consider","considerable","consideration",
    "consist","consistent","constant","constantly","constitute","constitutional","construct","construction","consultant","consume",
    "consumer","consumption","contact","contain","container","contemporary","content","contest","context","continue",
    "contract","contrast","contribute","contribution","control","controversial","controversy","convention","conversation","convert",
    "conviction","convince","cook","cookie","cooking","cool","cooperation","cop","cope","copy",
    "core","corner","corporate","correct","correspond","cost","cotton","couch","could","council",
    "count","counter","country","county","couple","courage","course","court","cousin","cover",
    "coverage","crack","craft","crash","crazy","cream","create","creation","creative","creature",
    "credit","crew","crime","criminal","crisis","criteria","critic","critical","criticism","crop",
    "cross","crowd","crucial","cry","crystal","cultural","culture","cup","cure","curious",
    "current","currently","curriculum","custom","customer","cut","cycle","curtain","curve","cushion",

    -- D words (180+)
    "dad","daily","damage","dance","danger","dangerous","dare","dark","darkness","data",
    "database","date","daughter","day","dead","deal","dealer","dear","death","debate",
    "debt","decade","decent","decide","decision","deck","declare","decline","decrease","deep",
    "deeply","deer","defeat","defend","defendant","defense","defensive","deficit","define","definitely",
    "definition","degree","delay","deliver","delivery","demand","democracy","democrat","democratic","demonstrate",
    "demonstration","deny","department","depend","dependent","depending","depict","depression","deputy","derive",
    "describe","description","desert","deserve","design","designer","desire","desk","desperate","despite",
    "destroy","destruction","detail","detailed","detect","determine","develop","developer","development","device",
    "devote","dialogue","diamond","dictionary","die","diet","differ","difference","different","differently",
    "difficult","difficulty","dig","digital","dimension","dinner","direct","direction","directly","director",
    "dirt","dirty","disability","disagree","disappear","disappoint","disaster","discipline","discourse","discover",
    "discovery","discrimination","discuss","discussion","disease","dish","dismiss","disorder","display","dispute",
    "distance","distant","distinct","distinction","distinguish","distribute","distribution","district","diverse","diversity",
    "divide","division","doctor","document","dog","dollar","domain","domestic","dominant","dominate",
    "door","double","doubt","down","downtown","dozen","draft","drag","drama","dramatic",
    "dramatically","draw","drawing","dream","dress","drink","drive","driver","drop","drug",
    "dry","due","during","dust","duty","dynamic","dawn","dagger","dairy","dam",

    -- E words (170+)
    "each","eager","ear","early","earn","earnings","earth","ease","easily","east",
    "eastern","easy","eat","echo","economic","economy","edge","edition","editor","educate",
    "education","educator","effect","effective","effectively","efficiency","efficient","effort","egg","eight",
    "either","elderly","elect","election","electric","electricity","electronic","element","eliminate","elite",
    "else","elsewhere","email","embrace","emerge","emergency","emission","emotion","emotional","emphasis",
    "emphasize","empire","employ","employee","employer","employment","empty","enable","encounter","encourage",
    "end","enemy","energy","enforcement","engage","engine","engineer","engineering","enjoy","enormous",
    "enough","ensure","enter","enterprise","entertainment","entire","entirely","entrance","entry","environment",
    "environmental","episode","equal","equally","equipment","era","error","escape","especially","essay",
    "essential","essentially","establish","establishment","estate","estimate","evaluate","evaluation","even","evening",
    "event","eventually","ever","every","everybody","everyday","everyone","everything","everywhere","evidence",
    "evil","evolution","evolve","exact","exactly","exam","examination","examine","example","exceed",
    "excellent","except","exception","exchange","exciting","executive","exercise","exhibit","exhibition","exist",
    "existence","existing","expand","expansion","expect","expectation","expense","expensive","experience","experiment",
    "expert","explain","explanation","explicit","explore","explosion","expose","exposure","extend","extension",
    "extensive","extent","external","extra","extraordinary","extreme","extremely","eye","eagle","earthquake",
    "ecosystem","elaborate","elegance","elephant","elevator","eligible","eloquent","emperor",

    -- F words (160+)
    "fabric","face","facility","fact","factor","factory","faculty","fail","failure","fair",
    "fairly","faith","fall","false","familiar","family","famous","fan","fantasy","far",
    "farm","farmer","fascinating","fashion","fast","fat","fate","father","fault","favor",
    "favorite","fear","feature","federal","fee","feed","feel","feeling","fellow","female",
    "fence","few","fewer","fiction","field","fifteen","fifth","fifty","fight","fighter",
    "figure","file","fill","film","final","finally","finance","financial","find","finding",
    "fine","finger","finish","fire","firm","first","fish","fit","five","fix",
    "flag","flame","flat","flavor","flee","flesh","flight","float","floor","flow",
    "flower","fly","focus","folk","follow","following","food","foot","football","for",
    "force","foreign","forest","forever","forget","form","formal","formation","former","formula",
    "forth","fortune","forward","found","foundation","founder","four","fourth","frame","framework",
    "free","freedom","freeze","frequency","frequent","frequently","fresh","friend","friendship","front",
    "fruit","frustration","fuel","full","fully","fun","function","fund","fundamental","funding",
    "funeral","funny","furniture","further","furthermore","future","fairy","falcon","famine","farewell",
    "fascinate","fatigue","feasible","feast","feather","feedback","fertile","festival","fierce","fireplace",
    "flexibility","flexible","flicker","flourish","fluctuate","fluent",

    -- G words (120+)
    "gain","galaxy","gallery","game","gang","gap","garage","garden","garlic","gas",
    "gate","gather","gaze","gear","gender","gene","general","generally","generate","generation",
    "genetic","genius","genre","gentle","gentleman","genuine","gesture","get","ghost","giant",
    "gift","gifted","girl","girlfriend","give","given","glad","glance","glass","global",
    "glory","glove","go","goal","god","gold","golden","golf","gone","good",
    "govern","government","governor","grab","grace","grade","gradually","graduate","grain","grand",
    "grandfather","grandmother","grant","grass","grave","gray","great","greatest","green","grocery",
    "ground","group","grow","growing","growth","guarantee","guard","guess","guest","guide",
    "guideline","guilty","guitar","gun","guy","geography","gigantic","glacier","glamour","glimpse",
    "gloomy","glossary","gossip","graceful","grammar","granite","graphic","grateful","gravity","greenhouse",
    "grief","grill","grip","groove","gross","guardian","guidance","guilt","gymnasium",

    -- H words (130+)
    "habit","habitat","hair","half","hall","halt","hand","handle","hang","happen",
    "happy","harbor","hard","hardly","harm","hat","hate","have","head","headline",
    "headquarters","health","healthy","hear","hearing","heart","heat","heaven","heavily","heavy",
    "heel","height","hell","hello","help","helpful","her","here","heritage","hero",
    "herself","hide","high","highlight","highly","hill","him","himself","hint","hip",
    "hire","his","historian","historic","historical","history","hit","hold","hole","holiday",
    "holy","home","homeless","honest","honor","hook","hope","hopefully","horizon","horror",
    "horse","hospital","host","hostile","hot","hotel","hour","house","household","housing",
    "how","however","huge","human","humor","hundred","hungry","hunt","hunter","hurt",
    "husband","hypothesis","harmony","harvest","hatred","haunt","hazard","headache","healing","heartbeat",
    "heavenly","hedge","heir","helpless","hemisphere","heroic","hesitate","hierarchy","highway","hillside",
    "hinder","hobby","hollow","homework","honesty","hormone","horrible","hospitality","hostage","humble",
    "humidity","hurricane","hybrid",

    -- I words (150+)
    "idea","ideal","identification","identify","identity","ignore","ill","illegal","illness","illustrate",
    "illustration","image","imagination","imagine","immediate","immediately","immigrant","immigration","impact","implement",
    "implication","imply","import","importance","important","impose","impossible","impress","impression","impressive",
    "improve","improvement","incident","include","including","income","increase","increasingly","incredible","incredibly",
    "indeed","independence","independent","index","indicate","indication","indicator","individual","industrial","industry",
    "infant","infection","inflation","influence","inform","information","initial","initially","initiative","injury",
    "inner","innocent","innovation","innovative","input","inquiry","insert","inside","insist","inspection",
    "inspector","inspiration","inspire","install","installation","instance","instead","institution","instruction","instructor",
    "instrument","insurance","intellectual","intelligence","intelligent","intend","intense","intensity","intention","interact",
    "interaction","interest","interested","interesting","internal","international","internet","interpret","interpretation","intervention",
    "interview","into","introduce","introduction","invade","invasion","invest","investigate","investigation","investigator",
    "investment","investor","invisible","invitation","invite","involve","involved","involvement","iron","island",
    "isolation","issue","item","itself","ice","icon","ideology","ignorance","illuminate","illusion",
    "immense","immune","imperative","imperial","impulse","inadequate","incentive","incorporate","indefinite","indigenous",
    "indirect","inevitable","infinite","infrastructure","ingredient","inhabit","inherit","initial","inject","inland",

    -- J words (50+)
    "jacket","jail","jam","january","jaw","jazz","jealous","jeans","jet","jewel",
    "jewelry","job","join","joint","joke","journal","journalist","journey","joy","judge",
    "judgment","juice","jump","junior","jury","just","justice","justify","jungle","junction",
    "jurisdiction","juvenile","jubilee","juggle","jumble","jeopardize","jolt","joyful","jubilant",

    -- K words (50+)
    "keen","keep","key","keyboard","kick","kid","kill","killer","killing","kind",
    "king","kiss","kitchen","knee","knife","knock","know","knowledge","knot","knit",
    "kindness","kingdom","kinetic","kindle","kit","kitten","kneel","knight","keynote","kidnap",

    -- L words (150+)
    "label","labor","laboratory","lack","lady","lake","land","landscape","lane","language",
    "lap","large","largely","laser","last","late","later","latter","laugh","laughter",
    "launch","law","lawn","lawsuit","lawyer","lay","layer","lead","leader","leadership",
    "leaf","league","lean","learn","learning","least","leather","leave","lecture","left",
    "leg","legacy","legal","legend","legislation","legitimate","lemon","length","less","lesson",
    "let","letter","level","liberal","liberty","library","license","lie","life","lifestyle",
    "lifetime","lift","light","like","likely","limit","limitation","limited","line","link",
    "lion","lip","list","listen","literally","literary","literature","little","live","living",
    "load","loan","lobby","local","locate","location","lock","long","look","loop",
    "loose","lord","lose","loss","lost","lot","loud","love","lovely","lover",
    "low","lower","luck","lunch","lung","luxury","ladder","lamp","landlord","landmark",
    "laptop","latitude","lavender","layout","leaflet","leap","legendary","leisure","lengthen","lens",
    "leopard","liability","liberation","likewise","limestone","linger","liquid","literacy","lively","livestock",
    "locomotive","lodge","logic","logical","lonely","longitude","loyalty",

    -- M words (200+)
    "machine","mad","magazine","magic","magnetic","magnificent","mail","main","mainly","maintain",
    "maintenance","major","majority","make","maker","male","mall","man","manage","management",
    "manager","manner","manufacturer","manufacturing","many","map","margin","mark","market","marketing",
    "marriage","married","marry","mask","mass","massive","master","match","material","math",
    "matter","may","maybe","mayor","meal","mean","meaning","meanwhile","measure","measurement",
    "meat","mechanism","media","medical","medication","medicine","medium","meet","meeting","member",
    "membership","memory","mental","mention","mentor","menu","merchant","mercy","mere","merely",
    "merge","message","metal","method","middle","might","military","milk","million","mind",
    "mine","mineral","minister","minor","minority","minute","miracle","mirror","miss","mission",
    "mistake","mix","mixture","model","moderate","modern","modest","modify","mom","moment",
    "money","monitor","month","mood","moon","moral","more","moreover","morning","mortgage",
    "most","mostly","mother","motion","motivation","motor","mount","mountain","mouse","mouth",
    "move","movement","movie","much","multiple","murder","muscle","museum","music","musical",
    "musician","must","mutual","mystery","myth","mansion","manuscript","maple","marathon","marble",
    "marine","marketplace","martial","marvel","masculine","masterpiece","mature","maximize","meadow","meaningful",
    "mechanic","medieval","meditation","melody","membrane","memorial","merchandise","mercury","metaphor","microscope",
    "midnight","migration","milestone","minimum","ministry","mischief","mislead","missile","molecule","momentum",
    "monastery","monopoly","monument","morality","mosquito","motivate","motto","municipal","mural","mythology",

    -- N words (120+)
    "nail","name","narrative","narrow","nation","national","natural","naturally","nature","naval",
    "near","nearby","nearly","necessarily","necessary","neck","need","negative","negotiate","negotiation",
    "neighbor","neighborhood","neither","nerve","nervous","net","network","never","nevertheless","new",
    "newly","news","newspaper","next","nice","night","nine","nobody","nod","noise",
    "none","nor","normal","normally","north","northern","nose","not","note","nothing",
    "notice","notion","novel","nowhere","nuclear","number","numerous","nurse","nut","naked",
    "namely","nap","napkin","narrate","nasty","nationwide","native","navigate","navigation","neat",
    "necessity","necklace","needle","neglect","negligence","neutral","newcomer","newsletter","nightmare","nitrogen",
    "noble","nominate","nomination","nonetheless","nonsense","noon","norm","notable","notably","notebook",
    "notify","notorious","nourish","nowadays","nuance","nucleus","nurture","nutrient","nutrition",

    -- O words (120+)
    "object","objection","objective","obligation","observation","observe","observer","obstacle","obtain","obvious",
    "obviously","occasion","occasionally","occupation","occupy","occur","ocean","odd","odds","offense",
    "offensive","offer","office","officer","official","often","oil","okay","old","once",
    "one","ongoing","online","only","onto","open","opening","operate","operation","operator",
    "opinion","opponent","opportunity","oppose","opposite","opposition","option","orange","order","ordinary",
    "organic","organization","organize","orientation","origin","original","other","otherwise","ought","outcome",
    "outdoor","output","outside","overcome","overlook","owe","own","owner","ownership","oak",
    "oath","obedience","obey","obscure","obsess","obsolete","obstruct","occupant","occurrence","octave",
    "offend","offspring","olive","omit","onset","opaque","opera","optimal","optimism","optimistic",
    "optional","orbit","orchestra","ordeal","ore","organism","ornament","orphan","orthodox","outbreak",
    "outfit","outlaw","outline","outlook","outrage","outstanding","oval","oven","overall","overflow",
    "overhead","overlap","overnight","oversee","overtime","overturn","overwhelm","oxygen",

    -- P words (250+)
    "pace","pack","package","page","paid","pain","painful","paint","painting","pair",
    "palace","pale","palm","pan","panel","panic","paper","parent","park","parking",
    "part","partially","participant","participate","participation","particular","particularly","partly","partner","partnership",
    "party","pass","passage","passenger","passion","past","path","patience","patient","pattern",
    "pause","pay","payment","peace","peaceful","peak","peer","penalty","people","per",
    "perceive","percent","percentage","perception","perfect","perfectly","perform","performance","perhaps","period",
    "permanent","permission","permit","person","personal","personality","personally","perspective","persuade","phase",
    "phenomenon","philosophy","phone","photo","photograph","photographer","photography","phrase","physical","physically",
    "physician","piano","pick","picture","pie","piece","pile","pilot","pine","pink",
    "pipe","pitch","place","plain","plan","plane","planet","planning","plant","plastic",
    "plate","platform","play","player","please","pleasure","plenty","plot","plus","pocket",
    "poem","poet","poetry","point","poison","police","policy","political","politically","politician",
    "politics","poll","pollution","pool","poor","pop","popular","popularity","population","porch",
    "port","portion","portrait","portray","position","positive","possess","possession","possibility","possible",
    "possibly","post","potential","potentially","pound","pour","poverty","power","powerful","practical",
    "practice","pray","prayer","precisely","predict","prediction","prefer","preference","pregnancy","pregnant",
    "preparation","prepare","presence","present","presentation","preserve","presidency","president","presidential","press",
    "pressure","presumably","pretend","pretty","prevent","previous","previously","price","pride","priest",
    "primarily","primary","prime","prince","princess","principal","principle","print","prior","priority",
    "prison","prisoner","privacy","private","privilege","prize","probably","problem","procedure","proceed",
    "process","produce","producer","product","production","profession","professional","professor","profile","profit",
    "program","progress","project","prominent","promise","promote","promotion","proof","proper","properly",
    "property","proportion","proposal","propose","prosecutor","prospect","protect","protection","protein","protest",
    "proud","prove","provide","provider","province","provision","psychological","psychologist","psychology","public",
    "publication","publicly","publish","pull","punishment","purchase","pure","purpose","pursue","push",
    "put","puzzle","paradise","paragraph","parallel","parameter","parcel","pardon","parliament","particle",
    "passionate","passive","passport","pathway","patriot","patrol","patron","pavilion","peasant","peculiar",
    "pedestrian","penetrate","pension","pepper","perfection","peripheral","persecute","persist","persistent","personnel",
    "petition","petroleum","pharmacy","phosphorus","physician","pilgrim","pioneer","pipeline","pistol","pixel",
    "plantation","plaza","plead","pledge","plumbing","plunge","polar","polite","populate","portable",
    "portfolio","postpone","practitioner","praise","precaution","precious","precise","predator","predecessor","prejudice",
    "preliminary","premier","premise","premium","prescribe","prescription","prestige","presume","prevail","prevalent",
    "primitive","privilege","probe","procession","proclaim","productive","profound","prohibit","projection","prolong",
    "prone","pronounce","propaganda","proposition","prosperity","protective","protocol","provoke","proximity","publicity",
    "pulse","pump","punctual","pupil","puppet","purple","pursuit","pyramid",

    -- Q words (30+)
    "qualification","qualify","quality","quantity","quarter","quarterback","queen","question","quick","quickly",
    "quiet","quietly","quit","quite","quote","quantum","quarantine","quarrel","quarterly","quest",
    "questionnaire","queue","quiz","quota","quotation",

    -- R words (200+)
    "race","racial","racism","rack","radical","radio","rage","rail","rain","raise",
    "range","rank","rapid","rapidly","rare","rarely","rate","rather","raw","reach",
    "react","reaction","read","reader","reading","ready","real","realistic","reality","realize",
    "really","reason","reasonable","recall","receive","recent","recently","recognition","recognize","recommend",
    "recommendation","record","recording","recover","recovery","recruit","red","reduce","reduction","refer",
    "reference","reflect","reflection","reform","refugee","refuse","regard","regarding","regime","region",
    "regional","register","regular","regularly","regulate","regulation","reinforce","reject","relate","relation",
    "relationship","relative","relatively","release","relevant","relief","religion","religious","reluctant","rely",
    "remain","remaining","remark","remarkable","remedy","remember","remind","remote","remove","repeat",
    "repeatedly","replace","replacement","reply","report","reporter","represent","representation","representative","reputation",
    "request","require","requirement","research","researcher","resemble","reservation","reserve","resident","residential",
    "resign","resist","resistance","resolution","resolve","resort","resource","respond","response","responsibility",
    "responsible","rest","restaurant","restore","restriction","result","retain","retire","retirement","return",
    "reveal","revenue","review","revolution","rhythm","rice","rich","ride","rifle","right",
    "ring","rise","risk","river","road","rock","role","roll","romantic","roof",
    "room","root","rope","rose","rough","roughly","round","route","routine","row",
    "royal","rule","run","running","rural","rush","rabbit","radar","radiation","rainbow",
    "rally","ranch","random","ratio","rational","realm","rear","rebel","rebuild","receipt",
    "recession","recipe","recipient","reckon","reconcile","reconstruct","recreation","rectangle","recycle","redeem",
    "referendum","refine","refuge","refund","regain","regret","rehearsal","reign","relay","relevance",
    "reliance","relieve","reluctance","remainder","renaissance","render","renewable","rental","repay","repeal",
    "repetition","replica","republic","rescue","resent","reservoir","reside","residue","resilience","resonance",
    "respective","restrain","resume","retail","retention","retrieve","retrospect","reunion","revelation","revenge",
    "reverse","revision","revival","revolt","ribbon","ridge","ridiculous","rigid","riot","ritual",
    "rivalry","robust","rocket","romance","roster","rotate","rotation","royalty","rubber","rude",
    "rugby","ruin","rumor","runway","rupture",

    -- S words (300+)
    "sacred","sacrifice","sad","safe","safety","sail","sake","salary","sale","salt",
    "same","sample","sanction","sand","satellite","satisfaction","satisfy","save","saving","say",
    "scale","scandal","scene","schedule","scheme","scholar","scholarship","school","science","scientific",
    "scientist","scope","score","screen","sea","search","season","seat","second","secondary",
    "secret","secretary","section","sector","secure","security","see","seed","seek","seem",
    "segment","seize","select","selection","self","sell","senate","senator","send","senior",
    "sense","sensitive","sentence","separate","sequence","series","serious","seriously","serve","service",
    "session","set","setting","settle","settlement","seven","several","severe","sexual","shade",
    "shadow","shake","shall","shape","share","sharp","she","shed","sheer","sheet",
    "shelf","shell","shelter","shift","shine","ship","shirt","shock","shoe","shoot",
    "shooting","shop","shopping","shore","short","shortly","shot","should","shoulder","shout",
    "show","shower","shut","sick","side","sight","sign","signal","significance","significant",
    "significantly","silence","silent","silver","similar","similarly","simple","simply","sin","since",
    "sing","singer","single","sir","sister","sit","site","situation","six","size",
    "ski","skill","skin","sky","slave","slavery","sleep","slice","slide","slight",
    "slightly","slip","slow","slowly","small","smart","smell","smile","smoke","smooth",
    "snap","snow","so","soccer","social","society","soft","software","soil","solar",
    "soldier","solid","solution","solve","some","somebody","somehow","someone","something","sometimes",
    "somewhat","somewhere","son","song","soon","sophisticated","sorry","sort","soul","sound",
    "source","south","southern","space","speak","speaker","special","specialist","species","specific",
    "specifically","speech","speed","spend","spending","sphere","spirit","spiritual","split","spokesman",
    "sport","spot","spread","spring","square","squeeze","stability","stable","staff","stage",
    "stair","stake","stand","standard","standing","star","stare","start","state","statement",
    "station","status","statute","stay","steady","steal","steam","steel","stem","step",
    "stick","stiff","still","stimulate","stock","stomach","stone","stop","storage","store",
    "storm","story","straight","strange","stranger","strategic","strategy","stream","street","strength",
    "strengthen","stress","stretch","strike","string","strip","stroke","strong","strongly","structure",
    "struggle","student","studio","study","stuff","stupid","style","subject","submit","subsequent",
    "substance","substantial","succeed","success","successful","successfully","such","sudden","suddenly","suffer",
    "sufficient","sugar","suggest","suggestion","suit","suitable","summer","summit","sun","super",
    "supply","support","supporter","suppose","sure","surely","surface","surgery","surprise","surprised",
    "surprising","surround","surrounding","survey","survival","survive","survivor","suspect","suspend","suspicion",
    "sustain","swallow","swear","sweet","swim","swing","switch","symbol","sympathy","symptom",
    "system","safari","safeguard","salmon","salvation","sanctuary","saturate","savage","scar","scarce",
    "scatter","scenario","scenery","scholarly","scissors","scoreboard","scout","scramble","scrap","scratch",
    "scripture","scrutiny","sculpture","seamless","seasonal","secular","sedan","sediment","seldom","semester",
    "sensation","sentiment","separation","sergeant","sermon","servant","setback","severity","shaft","shallow",
    "shame","shatter","shepherd","sheriff","shield","shimmer","shipment","shortage","shortcut","shrink",
    "sibling","sidewalk","siege","signature","silicon","simplicity","simulate","simultaneous","sincere","singular",
    "skeptic","skeleton","sketch","skilled","slam","slaughter","slender","slogan","slope","smash",
    "snapshot","soar","sober","socket","sodium","solemn","solitary","solo","someday","sonar",
    "sovereignty","spacecraft","span","spare","spark","spawn","specimen","spectacular","spectrum","speculate",
    "spill","spin","spiral","splash","spontaneous","sponsor","spotlight","spouse","spray","squad",
    "stagger","stain","staircase","stakeholder","stall","stance","staple","starve","static","statistics",
    "statue","steadily","steep","steering","stereotype","steward","stimulation","stimulus","stir","stitch",
    "stockholder","streak","stride","stripe","strive","stumble","stun","stunning","submarine","submission",
    "subscription","subsidiary","substitute","subtle","suburban","succession","successor","suffice","suite","sulfur",
    "sunlight","sunrise","sunset","sunshine","superb","superficial","superintendent","superior","supervise","supplement",
    "supreme","surge","surgeon","surplus","surrender","surveillance","suspension","sustainable","swamp","swap",
    "sweep","swell","swift","sword","syllable","symbolic","syndrome","synthesis","systematic",

    -- T words (200+)
    "table","tactic","tail","take","tale","talent","talk","tall","tank","tap",
    "tape","target","task","taste","tax","taxpayer","tea","teach","teacher","teaching",
    "team","tear","technology","telephone","television","tell","temperature","temporary","ten","tend",
    "tendency","tension","tent","term","terrible","territory","terror","terrorism","terrorist","test",
    "testimony","testing","text","than","thank","that","the","theater","their","them",
    "theme","themselves","then","theory","therapy","there","therefore","thick","thin","thing",
    "think","thinking","third","thirty","this","thorough","those","though","thought","thousand",
    "threat","threaten","three","throat","through","throughout","throw","thus","ticket","tide",
    "tie","tight","till","time","tiny","tip","tire","tissue","title","today",
    "toe","together","toll","tomorrow","tone","tonight","too","tool","top","topic",
    "toss","total","totally","touch","tough","tour","tourist","tournament","toward","towards",
    "tower","town","toy","trace","track","trade","tradition","traditional","traffic","tragedy",
    "trail","train","training","trait","transfer","transform","transformation","transition","translate","transmission",
    "transport","transportation","travel","treat","treatment","treaty","tree","tremendous","trend","trial",
    "tribe","trick","trigger","trip","triumph","troop","trouble","truck","true","truly",
    "trust","truth","try","tube","tunnel","turn","twelve","twenty","twice","twin",
    "twist","two","type","typical","typically","tackle","tag","tailor","tangible","tariff",
    "teamwork","teaspoon","teenage","telegram","telescope","temple","tenant","tender","terminal","terrain",
    "terrific","territorial","testify","textile","thankful","thereafter","thermal","thesis","thoughtful","threshold",
    "thrive","thumb","thunder","timber","timeline","timely","tin","tobacco","tolerance","tolerant",
    "tomb","toolbar","torch","tornado","torture","tourism","toxic","trademark","trader","trailer",
    "transaction","transcript","transit","transparency","transplant","trauma","traverse","treasure","treasury","tribunal",
    "tribute","trillion","triple","tropical","troublesome","trustee","tuition","tumor","turbulence","turnover",
    "tutor","twilight","tyranny",

    -- U words (80+)
    "ugly","ultimate","ultimately","unable","uncle","under","undergo","underlying","understand","understanding",
    "unemployment","unfair","unfortunate","unfortunately","unhappy","uniform","union","unique","unit","unite",
    "united","unity","universal","universe","university","unknown","unless","unlike","unlikely","until",
    "unusual","up","upon","upper","upset","urban","urge","us","use","used",
    "useful","user","usual","usually","utility","utilize","umbrella","unanimous","uncertain","uncertainty",
    "unconstitutional","uncover","undergraduate","undermine","undertake","undo","undoubtedly","uneasy","unfold","unified",
    "unify","unprecedented","unstable","unveil","upcoming","update","upgrade","uphold","upright","uprising",
    "upstream","uranium","usher","utmost","utter","utterance",

    -- V words (80+)
    "vacation","valley","valuable","value","van","variable","variation","variety","various","vary",
    "vast","vehicle","venture","version","versus","very","vessel","veteran","via","victim",
    "victory","video","view","viewer","village","violation","violence","violent","virtual","virtually",
    "virtue","virus","visible","vision","visit","visitor","visual","vital","vocabulary","voice",
    "volume","voluntary","volunteer","vote","voter","vulnerable","vacancy","vaccine","vacuum","vague",
    "vain","valid","validate","valve","vanish","vapor","vegetation","vein","velocity","vendor",
    "verbal","verdict","verify","verse","vertical","viable","vibrant","vice","vicinity","vicious",
    "viewpoint","vigorous","villain","vintage","violate","virgin","vivid","vocal","vocation","void",
    "volatile","volt","voyage",

    -- W words (150+)
    "wage","wait","wake","walk","wall","wander","want","war","warm","warn",
    "warning","wash","waste","watch","water","wave","way","we","weak","weakness",
    "wealth","weapon","wear","weather","web","website","wedding","week","weekend","weigh",
    "weight","welcome","welfare","well","west","western","wet","what","whatever","wheat",
    "wheel","when","whenever","where","whereas","wherever","whether","which","while","whisper",
    "white","who","whole","whom","whose","why","wide","widely","widespread","wife",
    "wild","will","willing","win","wind","window","wine","wing","winner","winter",
    "wire","wisdom","wise","wish","with","withdraw","withdrawal","within","without","witness",
    "woman","wonder","wonderful","wood","wooden","word","work","worker","working","works",
    "workshop","world","worried","worry","worse","worst","worth","worthy","would","wound",
    "wrap","write","writer","writing","wrong","waist","wallet","ward","wardrobe","warehouse",
    "warfare","warmth","warrant","warrior","waterfall","wavelength","wax","weaken","weave","webpage",
    "weed","weekday","weird","wellness","whale","whatsoever","wheelchair","whistle","wholesale","wicked",
    "width","wilderness","wildlife","willingness","witch","withstand","wolf","wool","workforce","workout",
    "workplace","worldwide","worship","worthwhile","wrath","wreck",

    -- X words
    "xenon","xenophobia","xerox","xylophone",

    -- Y words (30+)
    "yard","yeah","year","yell","yellow","yes","yesterday","yet","yield","you",
    "young","youngster","your","yours","yourself","youth","yacht","yarn","yearly","yearn",

    -- Z words (20+)
    "zero","zone","zoo","zeal","zealous","zenith","zinc","zip","zombie","zoom",
    "zodiac","zigzag","zipper","zucchini","zephyr"
}

-- ═══════════════════════════════════════════
-- ВИДАЛЕННЯ ДУБЛІКАТІВ ТА СОРТУВАННЯ
-- ═══════════════════════════════════════════

local function cleanDatabase(tbl)
    local seen = {}
    local result = {}
    for _, word in ipairs(tbl) do
        local lower = string.lower(word)
        if not seen[lower] then
            seen[lower] = true
            table.insert(result, lower)
        end
    end
    table.sort(result)
    return result
end

AllWords = cleanDatabase(AllWords)

-- ═══════════════════════════════════════════
-- ФУНКЦІЇ ПОШУКУ
-- ═══════════════════════════════════════════

local function searchWords(query)
    if not query or query == "" then return {} end
    query = string.lower(query)
    local startsWithResults = {}
    local containsResults = {}

    for _, word in ipairs(AllWords) do
        if string.sub(word, 1, #query) == query then
            table.insert(startsWithResults, word)
        elseif string.find(word, query, 1, true) then
            table.insert(containsResults, word)
        end
    end

    local final = {}
    for _, w in ipairs(startsWithResults) do table.insert(final, w) end
    for _, w in ipairs(containsResults) do table.insert(final, w) end
    return final
end

local function getWordsByLetter(letter)
    letter = string.lower(letter)
    local results = {}
    for _, word in ipairs(AllWords) do
        if string.sub(word, 1, 1) == letter then
            table.insert(results, word)
        end
    end
    return results
end

local function getLetterStats()
    local stats = {}
    for _, word in ipairs(AllWords) do
        local first = string.upper(string.sub(word, 1, 1))
        stats[first] = (stats[first] or 0) + 1
    end
    return stats
end

local function getRandomWord()
    return AllWords[math.random(1, #AllWords)]
end

-- ═══════════════════════════════════════════
-- ЗМІННІ СТАНУ
-- ═══════════════════════════════════════════

local currentResults = {}
local currentQuery = ""
local currentFilter = "None"
local searchHistory = {}
local favoriteWords = {}
local darkMode = true

-- ═══════════════════════════════════════════
-- СТВОРЕННЯ ВІКНА ReGUI
-- ═══════════════════════════════════════════

local Window = Library:Window({
    Text = "📖 WordMaster Dictionary v3.0 | ImGui SAMP",
    TextColor = Color3.fromRGB(50, 180, 255),
    Size = UDim2.new(0, 560, 0, 620),
    Position = UDim2.new(0.5, -280, 0.5, -310),
    Draggable = true,
    Resizable = true
})

-- ═══════════════════════════════════════════
-- ВКЛАДКА 1: ГОЛОВНИЙ ПОШУК
-- ═══════════════════════════════════════════

local SearchTab = Window:Tab({
    Text = "🔍 Search"
})

-- Статистика
SearchTab:Label({
    Text = "📊 Database: " .. tostring(#AllWords) .. " English words loaded",
    TextColor = Color3.fromRGB(80, 200, 120)
})

SearchTab:Separator()

-- Поле пошуку
local ResultLabel = SearchTab:Label({
    Text = "📝 Type below to search words...",
    TextColor = Color3.fromRGB(180, 180, 190)
})

local SearchInput = SearchTab:TextBox({
    Text = "Search words...",
    Callback = function(text)
        currentQuery = text

        if text == "" then
            ResultLabel:Set({
                Text = "📝 Type a letter or word to search...",
                TextColor = Color3.fromRGB(180, 180, 190)
            })
            currentResults = {}
            currentFilter = "None"
            return
        end

        local results = searchWords(text)
        currentResults = results
        currentFilter = "Search: '" .. text .. "'"

        -- Додати в історію
        local found = false
        for _, h in ipairs(searchHistory) do
            if h == text then found = true break end
        end
        if not found and #text > 0 then
            table.insert(searchHistory, 1, text)
            if #searchHistory > 20 then
                table.remove(searchHistory, #searchHistory)
            end
        end

        if #results == 0 then
            ResultLabel:Set({
                Text = "❌ No words found for '" .. text .. "'",
                TextColor = Color3.fromRGB(255, 80, 80)
            })
        else
            local displayCount = math.min(#results, 100)
            local resultText = "✅ Found " .. #results .. " words for '" .. text .. "':\n"
            resultText = resultText .. "═══════════════════════════════════\n"

            for i = 1, displayCount do
                local word = results[i]
                local num = string.format("%3d", i)
                resultText = resultText .. " " .. num .. ". " .. word .. " [" .. #word .. " letters]\n"
            end

            if #results > displayCount then
                resultText = resultText .. "\n... +" .. (#results - displayCount) .. " more words (refine search)\n"
            end

            resultText = resultText .. "═══════════════════════════════════"

            ResultLabel:Set({
                Text = resultText,
                TextColor = Color3.fromRGB(220, 220, 230)
            })
        end
    end
})

SearchTab:Separator()

-- Кнопка випадкового слова
SearchTab:Button({
    Text = "🎲 Random Word",
    Callback = function()
        local word = getRandomWord()
        ResultLabel:Set({
            Text = "🎲 Random Word: " .. string.upper(string.sub(word, 1, 1)) .. string.sub(word, 2) .. "\n   Letters: " .. #word .. "\n   First letter: " .. string.upper(string.sub(word, 1, 1)),
            TextColor = Color3.fromRGB(255, 200, 50)
        })
    end
})

-- Кнопка очистки
SearchTab:Button({
    Text = "🗑️ Clear Results",
    Callback = function()
        currentResults = {}
        currentQuery = ""
        currentFilter = "None"
        ResultLabel:Set({
            Text = "📝 Results cleared. Type to search...",
            TextColor = Color3.fromRGB(180, 180, 190)
        })
    end
})

-- ═══════════════════════════════════════════
-- ВКЛАДКА 2: ФІЛЬТР ПО БУКВАХ
-- ═══════════════════════════════════════════

local LetterTab = Window:Tab({
    Text = "🔤 Letters"
})

local LetterResultLabel = LetterTab:Label({
    Text = "🔤 Click any letter button to see all words starting with it",
    TextColor = Color3.fromRGB(180, 180, 190)
})

LetterTab:Separator()

local stats = getLetterStats()

-- Рядок 1: A-I
LetterTab:Label({
    Text = "━━━ Row 1: A - I ━━━",
    TextColor = Color3.fromRGB(50, 130, 246)
})

for i = 1, 9 do
    local letter = string.char(64 + i)
    local count = stats[letter] or 0

    LetterTab:Button({
        Text = "[ " .. letter .. " ] - " .. count .. " words",
        Callback = function()
            local words = getWordsByLetter(letter)
            local displayCount = math.min(#words, 80)
            local text = "🔤 Letter '" .. letter .. "' — " .. #words .. " words found:\n"
            text = text .. "═══════════════════════════════════\n"

            for j = 1, displayCount do
                local num = string.format("%3d", j)
                text = text .. " " .. num .. ". " .. words[j] .. "\n"
            end

            if #words > displayCount then
                text = text .. "\n... +" .. (#words - displayCount) .. " more\n"
            end

            text = text .. "═══════════════════════════════════"

            LetterResultLabel:Set({
                Text = text,
                TextColor = Color3.fromRGB(220, 220, 230)
            })
        end
    })
end

LetterTab:Separator()

-- Рядок 2: J-R
LetterTab:Label({
    Text = "━━━ Row 2: J - R ━━━",
    TextColor = Color3.fromRGB(50, 130, 246)
})

for i = 10, 18 do
    local letter = string.char(64 + i)
    local count = stats[letter] or 0

    LetterTab:Button({
        Text = "[ " .. letter .. " ] - " .. count .. " words",
        Callback = function()
            local words = getWordsByLetter(letter)
            local displayCount = math.min(#words, 80)
            local text = "🔤 Letter '" .. letter .. "' — " .. #words .. " words found:\n"
            text = text .. "═══════════════════════════════════\n"

            for j = 1, displayCount do
                local num = string.format("%3d", j)
                text = text .. " " .. num .. ". " .. words[j] .. "\n"
            end

            if #words > displayCount then
                text = text .. "\n... +" .. (#words - displayCount) .. " more\n"
            end

            text = text .. "═══════════════════════════════════"

            LetterResultLabel:Set({
                Text = text,
                TextColor = Color3.fromRGB(220, 220, 230)
            })
        end
    })
end

LetterTab:Separator()

-- Рядок 3: S-Z
LetterTab:Label({
    Text = "━━━ Row 3: S - Z ━━━",
    TextColor = Color3.fromRGB(50, 130, 246)
})

for i = 19, 26 do
    local letter = string.char(64 + i)
    local count = stats[letter] or 0

    LetterTab:Button({
        Text = "[ " .. letter .. " ] - " .. count .. " words",
        Callback = function()
            local words = getWordsByLetter(letter)
            local displayCount = math.min(#words, 80)
            local text = "🔤 Letter '" .. letter .. "' — " .. #words .. " words found:\n"
            text = text .. "═══════════════════════════════════\n"

            for j = 1, displayCount do
                local num = string.format("%3d", j)
                text = text .. " " .. num .. ". " .. words[j] .. "\n"
            end

            if #words > displayCount then
                text = text .. "\n... +" .. (#words - displayCount) .. " more\n"
            end

            text = text .. "═══════════════════════════════════"

            LetterResultLabel:Set({
                Text = text,
                TextColor = Color3.fromRGB(220, 220, 230)
            })
        end
    })
end

LetterTab:Separator()

-- Кнопка ALL
LetterTab:Button({
    Text = "📚 SHOW ALL WORDS (" .. #AllWords .. ")",
    Callback = function()
        local displayCount = math.min(#AllWords, 150)
        local text = "📚 ALL WORDS — " .. #AllWords .. " total:\n"
        text = text .. "═══════════════════════════════════\n"

        for j = 1, displayCount do
            local num = string.format("%4d", j)
            text = text .. " " .. num .. ". " .. AllWords[j] .. "\n"
        end

        if #AllWords > displayCount then
            text = text .. "\n... +" .. (#AllWords - displayCount) .. " more words\n"
        end

        text = text .. "═══════════════════════════════════"

        LetterResultLabel:Set({
            Text = text,
            TextColor = Color3.fromRGB(200, 220, 255)
        })
    end
})

-- ═══════════════════════════════════════════
-- ВКЛАДКА 3: РОЗШИРЕНИЙ ПОШУК
-- ═══════════════════════════════════════════

local AdvancedTab = Window:Tab({
    Text = "⚙️ Advanced"
})

local AdvResultLabel = AdvancedTab:Label({
    Text = "⚙️ Advanced search tools",
    TextColor = Color3.fromRGB(180, 180, 190)
})

AdvancedTab:Separator()

-- Пошук по довжині слова
AdvancedTab:Label({
    Text = "📏 Search by Word Length:",
    TextColor = Color3.fromRGB(50, 180, 255)
})

local selectedLength = 5

AdvancedTab:Slider({
    Text = "Word Length",
    Min = 1,
    Max = 20,
    Default = 5,
    Callback = function(value)
        selectedLength = value
    end
})

AdvancedTab:Button({
    Text = "🔍 Find Words by Length",
    Callback = function()
        local results = {}
        for _, word in ipairs(AllWords) do
            if #word == selectedLength then
                table.insert(results, word)
            end
        end

        local displayCount = math.min(#results, 100)
        local text = "📏 Words with " .. selectedLength .. " letters — " .. #results .. " found:\n"
        text = text .. "═══════════════════════════════════\n"

        for j = 1, displayCount do
            local num = string.format("%3d", j)
            text = text .. " " .. num .. ". " .. results[j] .. "\n"
        end

        if #results > displayCount then
            text = text .. "\n... +" .. (#results - displayCount) .. " more\n"
        end

        text = text .. "═══════════════════════════════════"

        AdvResultLabel:Set({
            Text = text,
            TextColor = Color3.fromRGB(220, 220, 230)
        })
    end
})

AdvancedTab:Separator()

-- Пошук слів що закінчуються на...
AdvancedTab:Label({
    Text = "🔚 Search by Ending:",
    TextColor = Color3.fromRGB(50, 180, 255)
})

AdvancedTab:TextBox({
    Text = "Enter ending (e.g. 'tion', 'ing', 'ly')",
    Callback = function(text)
        if text == "" then return end
        text = string.lower(text)

        local results = {}
        for _, word in ipairs(AllWords) do
            if string.sub(word, -#text) == text then
                table.insert(results, word)
            end
        end

        local displayCount = math.min(#results, 100)
        local resultText = "🔚 Words ending with '" .. text .. "' — " .. #results .. " found:\n"
        resultText = resultText .. "═══════════════════════════════════\n"

        for j = 1, displayCount do
            local num = string.format("%3d", j)
            resultText = resultText .. " " .. num .. ". " .. results[j] .. "\n"
        end

        if #results > displayCount then
            resultText = resultText .. "\n... +" .. (#results - displayCount) .. " more\n"
        end

        resultText = resultText .. "═══════════════════════════════════"

        AdvResultLabel:Set({
            Text = resultText,
            TextColor = Color3.fromRGB(220, 220, 230)
        })
    end
})

AdvancedTab:Separator()

-- Пошук слів що містять...
AdvancedTab:Label({
    Text = "🔎 Search by Contains:",
    TextColor = Color3.fromRGB(50, 180, 255)
})

AdvancedTab:TextBox({
    Text = "Enter substring (e.g. 'ght', 'ph', 'qu')",
    Callback = function(text)
        if text == "" then return end
        text = string.lower(text)

        local results = {}
        for _, word in ipairs(AllWords) do
            if string.find(word, text, 1, true) then
                table.insert(results, word)
            end
        end

        local displayCount = math.min(#results, 100)
        local resultText = "🔎 Words containing '" .. text .. "' — " .. #results .. " found:\n"
        resultText = resultText .. "═══════════════════════════════════\n"

        for j = 1, displayCount do
            local num = string.format("%3d", j)
            resultText = resultText .. " " .. num .. ". " .. results[j] .. "\n"
        end

        if #results > displayCount then
            resultText = resultText .. "\n... +" .. (#results - displayCount) .. " more\n"
        end

        resultText = resultText .. "═══════════════════════════════════"

        AdvResultLabel:Set({
            Text = resultText,
            TextColor = Color3.fromRGB(220, 220, 230)
        })
    end
})

AdvancedTab:Separator()

-- Пошук по кількості голосних
AdvancedTab:Label({
    Text = "🔡 Vowel Count Search:",
    TextColor = Color3.fromRGB(50, 180, 255)
})

local selectedVowels = 3

AdvancedTab:Slider({
    Text = "Vowel Count",
    Min = 0,
    Max = 10,
    Default = 3,
    Callback = function(value)
        selectedVowels = value
    end
})

AdvancedTab:Button({
    Text = "🔍 Find by Vowel Count",
    Callback = function()
        local vowels = {a=true, e=true, i=true, o=true, u=true}
        local results = {}

        for _, word in ipairs(AllWords) do
            local count = 0
            for c in word:gmatch(".") do
                if vowels[c] then count = count + 1 end
            end
            if count == selectedVowels then
                table.insert(results, word .. " (" .. count .. " vowels)")
            end
        end

        local displayCount = math.min(#results, 80)
        local text = "🔡 Words with " .. selectedVowels .. " vowels — " .. #results .. " found:\n"
        text = text .. "═══════════════════════════════════\n"

        for j = 1, displayCount do
            local num = string.format("%3d", j)
            text = text .. " " .. num .. ". " .. results[j] .. "\n"
        end

        if #results > displayCount then
            text = text .. "\n... +" .. (#results - displayCount) .. " more\n"
        end

        text = text .. "═══════════════════════════════════"

        AdvResultLabel:Set({
            Text = text,
            TextColor = Color3.fromRGB(220, 220, 230)
        })
    end
})

-- ═══════════════════════════════════════════
-- ВКЛАДКА 4: СТАТИСТИКА
-- ═══════════════════════════════════════════

local StatsTab = Window:Tab({
    Text = "📊 Statistics"
})

local StatsLabel = StatsTab:Label({
    Text = "Loading statistics...",
    TextColor = Color3.fromRGB(180, 180, 190)
})

-- Побудова статистики
local function buildStats()
    local letterStats = getLetterStats()
    local text = "╔═══════════════════════════════════════════╗\n"
    text = text ..  "║     📊 WordMaster Dictionary Statistics   ║\n"
    text = text ..  "╠═══════════════════════════════════════════╣\n"
    text = text ..  "║                                           ║\n"
    text = text ..  "║  📚 Total Words: " .. string.format("%-25s", tostring(#AllWords)) .. "║\n"
    text = text ..  "║  🔤 Letters Used: 26 (A-Z)                ║\n"
    text = text ..  "║                                           ║\n"
    text = text ..  "╠═══════════════════════════════════════════╣\n"
    text = text ..  "║     Words Per Letter:                     ║\n"
    text = text ..  "╠═══════════════════════════════════════════╣\n"

    -- Знайти максимум для графіку
    local maxCount = 0
    for _, count in pairs(letterStats) do
        if count > maxCount then maxCount = count end
    end

    for i = 1, 26 do
        local letter = string.char(64 + i)
        local count = letterStats[letter] or 0
        local barLen = math.floor((count / math.max(maxCount, 1)) * 20)
        local bar = string.rep("█", barLen) .. string.rep("░", 20 - barLen)

        text = text .. "║  " .. letter .. " │ " .. bar .. " │ " .. string.format("%3d", count) .. " ║\n"
    end

    text = text .. "╠═══════════════════════════════════════════╣\n"

    -- Найдовше та найкоротше слово
    local longest = ""
    local shortest = AllWords[1] or ""
    for _, word in ipairs(AllWords) do
        if #word > #longest then longest = word end
        if #word < #shortest then shortest = word end
    end

    -- Середня довжина
    local totalLen = 0
    for _, word in ipairs(AllWords) do
        totalLen = totalLen + #word
    end
    local avgLen = totalLen / #AllWords

    text = text .. "║                                           ║\n"
    text = text .. "║  📏 Longest:  " .. string.format("%-28s", longest .. " (" .. #longest .. " ch)") .. "║\n"
    text = text .. "║  📐 Shortest: " .. string.format("%-28s", shortest .. " (" .. #shortest .. " ch)") .. "║\n"
    text = text .. "║  📊 Average:  " .. string.format("%-28s", string.format("%.1f", avgLen) .. " characters") .. "║\n"
    text = text .. "║                                           ║\n"

    -- Розподіл по довжині
    text = text .. "╠═══════════════════════════════════════════╣\n"
    text = text .. "║     Length Distribution:                  ║\n"
    text = text .. "╠═══════════════════════════════════════════╣\n"

    local lenDist = {}
    for _, word in ipairs(AllWords) do
        local l = #word
        lenDist[l] = (lenDist[l] or 0) + 1
    end

    for len = 1, 15 do
        local count = lenDist[len] or 0
        if count > 0 then
            local barLen2 = math.floor((count / math.max(maxCount, 1)) * 18)
            local bar2 = string.rep("▓", barLen2) .. string.rep("░", 18 - barLen2)
            text = text .. "║  " .. string.format("%2d", len) .. " ch │ " .. bar2 .. " │ " .. string.format("%3d", count) .. "  ║\n"
        end
    end

    text = text .. "╚═══════════════════════════════════════════╝"

    return text
end

StatsLabel:Set({
    Text = buildStats(),
    TextColor = Color3.fromRGB(200, 210, 230)
})

StatsTab:Separator()

StatsTab:Button({
    Text = "🔄 Refresh Statistics",
    Callback = function()
        StatsLabel:Set({
            Text = buildStats(),
            TextColor = Color3.fromRGB(200, 210, 230)
        })
    end
})

-- ═══════════════════════════════════════════
-- ВКЛАДКА 5: ІНСТРУМЕНТИ
-- ═══════════════════════════════════════════

local ToolsTab = Window:Tab({
    Text = "🛠️ Tools"
})

local ToolResultLabel = ToolsTab:Label({
    Text = "🛠️ Word tools and utilities",
    TextColor = Color3.fromRGB(180, 180, 190)
})

ToolsTab:Separator()

-- Word Scramble Game
ToolsTab:Label({
    Text = "🎮 Word Scramble Game:",
    TextColor = Color3.fromRGB(255, 200, 50)
})

local scrambleAnswer = ""

ToolsTab:Button({
    Text = "🔀 New Scrambled Word",
    Callback = function()
        local word = getRandomWord()
        scrambleAnswer = word

        -- Перемішати букви
        local chars = {}
        for c in word:gmatch(".") do
            table.insert(chars, c)
        end

        for i = #chars, 2, -1 do
            local j = math.random(i)
            chars[i], chars[j] = chars[j], chars[i]
        end

        local scrambled = table.concat(chars)

        ToolResultLabel:Set({
            Text = "🔀 Unscramble this word:\n\n   ➤ " .. string.upper(scrambled) .. "\n\n   Hint: " .. #word .. " letters, starts with '" .. string.upper(string.sub(word, 1, 1)) .. "'\n\n   Type your guess below!",
            TextColor = Color3.fromRGB(255, 200, 50)
        })
    end
})

ToolsTab:TextBox({
    Text = "Type your guess...",
    Callback = function(text)
        if scrambleAnswer == "" then
            ToolResultLabel:Set({
                Text = "⚠️ Click 'New Scrambled Word' first!",
                TextColor = Color3.fromRGB(255, 180, 50)
            })
            return
        end

        if string.lower(text) == scrambleAnswer then
            ToolResultLabel:Set({
                Text = "🎉 CORRECT! The word was: " .. string.upper(scrambleAnswer) .. "\n\n   Great job! Click for a new word!",
                TextColor = Color3.fromRGB(80, 200, 120)
            })
            scrambleAnswer = ""
        else
            ToolResultLabel:Set({
                Text = "❌ Wrong! Try again!\n\n   Your guess: " .. text .. "\n   Hint: The word has " .. #scrambleAnswer .. " letters",
                TextColor = Color3.fromRGB(255, 80, 80)
            })
        end
    end
})

ToolsTab:Separator()

-- Генератор паролів зі слів
ToolsTab:Label({
    Text = "🔐 Word-Based Password Generator:",
    TextColor = Color3.fromRGB(50, 180, 255)
})

ToolsTab:Button({
    Text = "🔐 Generate Password",
    Callback = function()
        local w1 = getRandomWord()
        local w2 = getRandomWord()
        local w3 = getRandomWord()
        local num = tostring(math.random(10, 99))
        local symbols = {"!", "@", "#", "$", "%", "&", "*"}
        local sym = symbols[math.random(1, #symbols)]

        local password = string.upper(string.sub(w1, 1, 1)) .. string.sub(w1, 2) .. sym .. string.upper(string.sub(w2, 1, 1)) .. string.sub(w2, 2) .. num .. string.upper(string.sub(w3, 1, 1)) .. string.sub(w3, 2)

        ToolResultLabel:Set({
            Text = "🔐 Generated Password:\n\n   ➤ " .. password .. "\n\n   Words used: " .. w1 .. ", " .. w2 .. ", " .. w3 .. "\n   Length: " .. #password .. " characters\n   Strength: ████████████ Strong",
            TextColor = Color3.fromRGB(80, 200, 120)
        })
    end
})

ToolsTab:Separator()

-- Підрахунок символів
ToolsTab:Label({
    Text = "📊 Word Analyzer:",
    TextColor = Color3.fromRGB(50, 180, 255)
})

ToolsTab:TextBox({
    Text = "Enter a word to analyze...",
    Callback = function(text)
        if text == "" then return end
        text = string.lower(text)

        local vowels = {a=true, e=true, i=true, o=true, u=true}
        local vowelCount = 0
        local consonantCount = 0
        local charFreq = {}

        for c in text:gmatch(".") do
            charFreq[c] = (charFreq[c] or 0) + 1
            if vowels[c] then
                vowelCount = vowelCount + 1
            elseif c:match("%a") then
                consonantCount = consonantCount + 1
            end
        end

        -- Перевірити чи є в базі
        local inDatabase = false
        for _, word in ipairs(AllWords) do
            if word == text then
                inDatabase = true
                break
            end
        end

        local result = "📊 Analysis of '" .. text .. "':\n"
        result = result .. "═══════════════════════════════════\n"
        result = result .. "   📏 Length: " .. #text .. " characters\n"
        result = result .. "   🔤 Vowels: " .. vowelCount .. "\n"
        result = result .. "   🔡 Consonants: " .. consonantCount .. "\n"
        result = result .. "   📖 In Database: " .. (inDatabase and "✅ Yes" or "❌ No") .. "\n"
        result = result .. "   \n"
        result = result .. "   Character Frequency:\n"

        for char, freq in pairs(charFreq) do
            result = result .. "   '" .. char .. "' = " .. freq .. "x " .. string.rep("█", freq) .. "\n"
        end

        -- Знайти схожі слова
        local similar = {}
        for _, word in ipairs(AllWords) do
            if string.sub(word, 1, math.min(3, #text)) == string.sub(text, 1, math.min(3, #text)) and word ~= text then
                table.insert(similar, word)
                if #similar >= 10 then break end
            end
        end

        if #similar > 0 then
            result = result .. "\n   Similar words: " .. table.concat(similar, ", ")
        end

        result = result .. "\n═══════════════════════════════════"

        ToolResultLabel:Set({
            Text = result,
            TextColor = Color3.fromRGB(220, 220, 230)
        })
    end
})

-- ═══════════════════════════════════════════
-- ВКЛАДКА 6: FAVORITES & HISTORY
-- ═══════════════════════════════════════════

local HistoryTab = Window:Tab({
    Text = "📋 History"
})

local HistoryLabel = HistoryTab:Label({
    Text = "📋 Search history will appear here",
    TextColor = Color3.fromRGB(180, 180, 190)
})

HistoryTab:Separator()

-- Favorites
HistoryTab:Label({
    Text = "⭐ Add Word to Favorites:",
    TextColor = Color3.fromRGB(255, 200, 50)
})

HistoryTab:TextBox({
    Text = "Type word to add to favorites...",
    Callback = function(text)
        if text == "" then return end
        text = string.lower(text)

        local exists = false
        for _, w in ipairs(favoriteWords) do
            if w == text then exists = true break end
        end

        if not exists then
            table.insert(favoriteWords, text)
        end

        local favText = "⭐ Favorite Words (" .. #favoriteWords .. "):\n"
        favText = favText .. "═══════════════════════════════════\n"
        for i, word in ipairs(favoriteWords) do
            favText = favText .. "  " .. i .. ". " .. word .. "\n"
        end
        favText = favText .. "═══════════════════════════════════"

        HistoryLabel:Set({
            Text = favText,
            TextColor = Color3.fromRGB(255, 200, 50)
        })
    end
})

HistoryTab:Separator()

HistoryTab:Button({
    Text = "📜 Show Search History",
    Callback = function()
        if #searchHistory == 0 then
            HistoryLabel:Set({
                Text = "📜 No search history yet. Start searching!",
                TextColor = Color3.fromRGB(180, 180, 190)
            })
            return
        end

        local text = "📜 Search History (last " .. #searchHistory .. "):\n"
        text = text .. "═══════════════════════════════════\n"
        for i, query in ipairs(searchHistory) do
            local results = searchWords(query)
            text = text .. "  " .. i .. ". '" .. query .. "' → " .. #results .. " results\n"
        end
        text = text .. "═══════════════════════════════════"

        HistoryLabel:Set({
            Text = text,
            TextColor = Color3.fromRGB(200, 210, 230)
        })
    end
})

HistoryTab:Button({
    Text = "⭐ Show Favorites",
    Callback = function()
        if #favoriteWords == 0 then
            HistoryLabel:Set({
                Text = "⭐ No favorites yet. Add some words!",
                TextColor = Color3.fromRGB(180, 180, 190)
            })
            return
        end

        local text = "⭐ Favorite Words (" .. #favoriteWords .. "):\n"
        text = text .. "═══════════════════════════════════\n"
        for i, word in ipairs(favoriteWords) do
            text = text .. "  " .. i .. ". " .. word .. " [" .. #word .. " letters]\n"
        end
        text = text .. "═══════════════════════════════════"

        HistoryLabel:Set({
            Text = text,
            TextColor = Color3.fromRGB(255, 200, 50)
        })
    end
})

HistoryTab:Button({
    Text = "🗑️ Clear History",
    Callback = function()
        searchHistory = {}
        HistoryLabel:Set({
            Text = "📜 History cleared!",
            TextColor = Color3.fromRGB(80, 200, 120)
        })
    end
})

HistoryTab:Button({
    Text = "🗑️ Clear Favorites",
    Callback = function()
        favoriteWords = {}
        HistoryLabel:Set({
            Text = "⭐ Favorites cleared!",
            TextColor = Color3.fromRGB(80, 200, 120)
        })
    end
})

-- ═══════════════════════════════════════════
-- ВКЛАДКА 7: НАЛАШТУВАННЯ
-- ═══════════════════════════════════════════

local SettingsTab = Window:Tab({
    Text = "⚙️ Settings"
})

SettingsTab:Label({
    Text = "╔═══════════════════════════════════╗",
    TextColor = Color3.fromRGB(50, 130, 246)
})
SettingsTab:Label({
    Text = "║  📖 WordMaster Dictionary v3.0    ║",
    TextColor = Color3.fromRGB(50, 180, 255)
})
SettingsTab:Label({
    Text = "║  Built with ReGUI Library         ║",
    TextColor = Color3.fromRGB(180, 180, 190)
})
SettingsTab:Label({
    Text = "║  ImGui SAMP Style                 ║",
    TextColor = Color3.fromRGB(180, 180, 190)
})
SettingsTab:Label({
    Text = "╚═══════════════════════════════════╝",
    TextColor = Color3.fromRGB(50, 130, 246)
})

SettingsTab:Separator()

SettingsTab:Label({
    Text = "📊 Quick Info:",
    TextColor = Color3.fromRGB(255, 200, 50)
})

SettingsTab:Label({
    Text = "  📚 Words in Database: " .. #AllWords,
    TextColor = Color3.fromRGB(80, 200, 120)
})

SettingsTab:Label({
    Text = "  🔤 Covered Letters: A through Z",
    TextColor = Color3.fromRGB(80, 200, 120)
})

SettingsTab:Label({
    Text = "  🎮 Features: Search, Filter, Stats, Game, Tools",
    TextColor = Color3.fromRGB(80, 200, 120)
})

SettingsTab:Separator()

SettingsTab:Label({
    Text = "📌 Controls:",
    TextColor = Color3.fromRGB(50, 180, 255)
})

SettingsTab:Label({
    Text = "  ↕ Drag titlebar to move window",
    TextColor = Color3.fromRGB(180, 180, 190)
})

SettingsTab:Label({
    Text = "  ◢ Drag corner to resize",
    TextColor = Color3.fromRGB(180, 180, 190)
})

SettingsTab:Label({
    Text = "  🔍 Type in search to find words instantly",
    TextColor = Color3.fromRGB(180, 180, 190)
})

SettingsTab:Label({
    Text = "  🔤 Click letter buttons for quick filter",
    TextColor = Color3.fromRGB(180, 180, 190)
})

SettingsTab:Separator()

SettingsTab:Toggle({
    Text = "🌙 Show Notifications",
    Default = true,
    Callback = function(value)
        if value then
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "📖 WordMaster",
                Text = "Notifications enabled!",
                Duration = 3
            })
        end
    end
})

SettingsTab:Separator()

SettingsTab:Button({
    Text = "🔄 Reload Database",
    Callback = function()
        AllWords = cleanDatabase(AllWords)
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "📖 WordMaster",
            Text = "Database reloaded: " .. #AllWords .. " words",
            Duration = 3
        })
    end
})

SettingsTab:Button({
    Text = "❌ Close Dictionary",
    Callback = function()
        Window:Destroy()
    end
})

-- ═══════════════════════════════════════════
-- НОТИФІКАЦІЯ ПРО ЗАВАНТАЖЕННЯ
-- ═══════════════════════════════════════════

pcall(function()
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "📖 WordMaster Dictionary",
        Text = "Loaded! " .. #AllWords .. " words | 7 Tabs | ReGUI",
        Duration = 5
    })
end)

-- ═══════════════════════════════════════════
-- КОНСОЛЬНИЙ ВИВІД
-- ═══════════════════════════════════════════

print("╔══════════════════════════════════════════════╗")
print("║     📖 WordMaster Dictionary v3.0           ║")
print("║     Built with ReGUI Library                ║")
print("║     ImGui SAMP Style                        ║")
print("╠══════════════════════════════════════════════╣")
print("║  📚 Total Words: " .. string.format("%-27s", tostring(#AllWords)) .. "║")
print("║  🔤 Letters: A-Z (26)                       ║")
print("║  📑 Tabs: 7 (Search, Letters, Advanced,     ║")
print("║          Stats, Tools, History, Settings)    ║")
print("╠══════════════════════════════════════════════╣")
print("║  Features:                                  ║")
print("║  ✅ Real-time search                        ║")
print("║  ✅ Letter filter (A-Z buttons)             ║")
print("║  ✅ Search by ending                        ║")
print("║  ✅ Search by word length                   ║")
print("║  ✅ Search by contains                      ║")
print("║  ✅ Vowel count search                      ║")
print("║  ✅ Word scramble game                      ║")
print("║  ✅ Password generator                      ║")
print("║  ✅ Word analyzer                           ║")
print("║  ✅ Favorites & History                     ║")
print("║  ✅ Full statistics with graphs             ║")
print("║  ✅ Draggable & Resizable window            ║")
print("╚══════════════════════════════════════════════╝")
