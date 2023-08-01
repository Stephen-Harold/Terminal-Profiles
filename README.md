# Terminal Profiles

#### MacOS terminal profiles for zsh and bash.

> I wipe my about every four months or so depending on what crap I've accumulated from various projects, customer files etc.
> 
> 
Malware is is attacking every Mac these days. Apple is doing a great job of stopping the malware from doing any real damage but it does get some information and does just hang around on your machine afterwards.
Thats why I do reinstall.

> All my important files are on github or iCloud and sync post reinstall. Thats why I built this profile management system.
It's a relatively simple system where the main objective is to save me rewriting code. 

> In that vain the ``` common.d ``` directory contains items common to all profiles. Then each shell has it's own version of a profile and handles information unique to that shell. I seperate the information into several files:

```

```

> Post install I can clone the repo into ~/.local/profiles and all the paths work, job done.

> This also means I can have some consistency across installations that allow me to type this sort of thing..

```
  echo ${RED}RND_NUM: ${BLUE}"$RANDOM" ${RESET}
```

