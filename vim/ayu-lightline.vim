let s:style = get(g:, 'ayucolor', 'dark')

let s:fg = {}
let s:fg.primary    = {'dark': '#E6E1CF', 'light': '#5C6773', 'mirage': '#D9D7CE'}[s:style]
let s:fg.secondary  = {'dark': '#14191F', 'light': '#F0F0F0', 'mirage': '#232838'}[s:style]
let s:fg.contrast   = {'dark': '#C2D94C', 'light': '#86B300', 'mirage': '#BAE67E'}[s:style]
let s:fg.warning    = {'dark': '#FFBD54', 'light': '#F2AE49', 'mirage': '#FFDF80'}[s:style]
let s:fg.error      = {'dark': '#FF3333', 'light': '#FFF333', 'mirage': '#FF3333'}[s:style]

let s:bg = {}
let s:bg.primary    = {'dark': '#161F2A', 'light': '#DEE8F1', 'mirage': '#2A3546'}[s:style]
let s:bg.secondary  = {'dark': '#14191F', 'light': '#F0F0F0', 'mirage': '#232838'}[s:style]
let s:bg.tertiary   = '#3E4B59'
let s:bg.tertiary_darker = '#253340'
let s:bg.contrast   = {'dark': '#E6B450', 'light': '#FF9940', 'mirage': '#FFCC66'}[s:style]
let s:bg.normal     = {'dark': '#B8CC52', 'light': '#D3D5D7', 'mirage': '#141925'}[s:style]
let s:bg.insert     = {'dark': '#39BAE6', 'light': '#55B4D4', 'mirage': '#5CCFE6'}[s:style]
let s:bg.replace    = {'dark': '#FF8F40', 'light': '#FA8D3E', 'mirage': '#FFA759'}[s:style]
let s:bg.visual     = {'dark': '#A37ACC', 'light': '#A37ACC', 'mirage': '#D4BFFF'}[s:style]

let s:p = {'normal': {}, 'inactive': {}, 'insert': {}, 'replace': {}, 'visual': {}, 'tabline': {}}
let s:p.normal.left     = [[s:fg.secondary, s:bg.normal, 'bold'], [s:fg.primary, s:bg.tertiary], [s:fg.primary, s:bg.tertiary_darker]]
let s:p.normal.right    = [[s:fg.primary, s:bg.tertiary], [s:fg.primary, s:bg.tertiary_darker]]
let s:p.normal.middle   = [[s:fg.primary, s:bg.secondary]]
let s:p.normal.error    = [[s:fg.error, s:bg.primary, 'bold']]
let s:p.normal.warning  = [[s:fg.warning, s:bg.primary, 'bold']]
let s:p.inactive.left   = [[s:fg.primary, s:bg.secondary]]
let s:p.inactive.right  = [[s:fg.primary, s:bg.secondary]]
let s:p.inactive.middle = [[s:fg.primary, s:bg.secondary]]
let s:p.insert.left     = [[s:fg.secondary, s:bg.insert, 'bold'], [s:fg.primary, '#206880'], [s:fg.primary, '#164859']]
let s:p.insert.right    = [[s:fg.primary, '#206880'], [s:fg.primary, '#164859']]
let s:p.insert.middle   = [[s:fg.primary, '#103440']]
let s:p.replace.left    = [[s:fg.secondary, s:bg.replace, 'bold'], [s:fg.primary, '#804820'], [s:fg.primary, '#593216']]
let s:p.replace.right   = [[s:fg.primary, '#804820'], [s:fg.primary, '#593216']]
let s:p.replace.middle  = [[s:fg.primary, '#412410']]
let s:p.visual.left     = [[s:fg.secondary, s:bg.visual, 'bold'], [s:fg.primary, '#654c7f'], [s:fg.primary, '#473559']]
let s:p.visual.right    = [[s:fg.primary, '#654c7f'], [s:fg.primary, '#473559']]
let s:p.visual.middle   = [[s:fg.primary, '#332640']]
let s:p.tabline.left    = [[s:fg.primary, s:bg.primary]]
let s:p.tabline.tabsel  = [[s:fg.secondary, s:bg.contrast]]

let g:lightline#colorscheme#ayu_custom#palette = lightline#colorscheme#fill(s:p)
