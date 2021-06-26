# NVIM Config and VIM Migration to NVIM Story

## Synposis

For a VIM user for now 8+ years and maintaining dotfiles for it i just
created this config and moving from my beloved VIM configuration to nvim  
and revisiting most of my configuration i noticed a lack of features and  
also a a lot of unused features  
repetitive annoying behaviour or to compicated tasks done fast and easy is key  
when i used to use spacemacs(emacs) i really loved the intuitive key maps  
also it gave me good ideas on how to improve my vim configuration  
and i found a lot of features there which i don't wanna miss now  
so how does this all translate into this config ?

Started 09.04.21

## The Main Goals

CONFIG SETUP:  

- make vim more like an IDE ✅
- Debloating the Config ✅
- remove unused plugins ✅
- move to the build in LSP ✅
  - Java LSP ❓
- Debug ☑️
  - Typescript NodeJS
  - Browser Javascript ❓
  - Rust ❓
  - Go ❓
  - Python ❓
  - Java ❓
- intutive mappings ✅
- fast tab/buffer navigation ✅
- project managment ✅
- session managment ✅
- file managment ✅
- lazy load plugins ✅
- Treesitter Setup ☑️
  - HI and FOLD Waits for TS/TSX merges so TS not supported ❓
- DONE AS OF 18.05.21

ENGRAVE WORKFLOW:  

- use quickfix list and location list ✅
- use cdo/argdo to execute stuff over quickfix/arglist buffers ✅
- properly use ctrl o / i  jumplist and shift ^ ✅
- use changelist ✅
- learn vim regex properly \v with capture groups etc ✅
- Treesitter Textobjects *TODO*
- Journaling with Vimwiki *TODO*

## Philosophy

### Do you really need this?

Often times over the span of experience i realized a lot of plugins  
are really not needed because vim can do them natively  
while its preference in some cases on how certain actions happen  
if you use for example easymotion vs relative number jumps with F(find) and T(till) jumps  
i think limiting yourself to those plugins will not let you embrance the full capabillities of VIM  
you won't use f and t as well as relative jumps for vertical navigation  
what will happen in most cases is you'll jump to a specific word and then go from there  
instead of training youself to see a 13 lines below a starting function and press 13jf{  
instead you'll do leader leader w llllllll  
maybe you won't but thats what i did starting using this plugin  
sometimes you hurt yourself more then it's actually usefull

### Get to know VIM and advance

Often people are stuck in a Zone of comfort when coming to a Point where they  
are acostumed to their current working habits  
this also goes for vim challange yourself and find better solutions  
often times i ask myself on how much time i actually save vs configurating VIM  
i stoped asking because i do it for fun  
so if you feel like you wanna be faster and more efficiant then go for it  
learn outside your comfort zone try around what happens when you press certain keys  
or look up a cheat sheet of vim to see the usages of your not so often vim features
