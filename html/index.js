const App = Vue.createApp({
    data() {
      return {
        opened : false,
        colorVars: {
            '--primary': '#4361ee',
            '--primary-dark': '#3a56d4',
            '--secondary': '#3f37c9',
            '--dark': '#1a1a2e',
            '--darker': '#16213e',
            '--light': '#f8f9fa',
            '--danger': '#e63946',
            '--success': '#2a9d8f',
            '--warning': '#f4a261',
            '--info': '#4cc9f0',
            '--border-radius': '8px',
            '--transition': 'all 0.2s ease'
        },
        players : [
            {id:1, name:"6osvillamos", group:"admin", job:"Rendőr - Kadét", bank:1500, Penz:999999},
        ],
        state : {
            group:"user",
            timeinduty:"0h 00m",
            duty:false,
            tag:false,
            ids:false,
            god:false,
            speed:false,
            invisible:false,
            adminzone:false,
            noragdoll:false
        },
        locales: {
            nui_label:"ADMIN DUTY PANEL",
            nui_group:"Your group",
            nui_players:"Players",
            nui_clockedtime:"Duty Time",
            nui_duty:"Duty",
            nui_tag:"Admin tag",
            nui_esp:"Show IDs",
            nui_god:"God mode",
            nui_speed:"Speed",
            nui_invisble:"Invisible",
            nui_adminzone:"Adminzone",
            nui_noragdoll:"No Ragdoll",
            nui_coords:"Coords",
            nui_health:"Health",
            nui_marker:"Marker",
            nui_label_players:"PLAYERS",
            nui_players_refresh:"Refresh",
            nui_players_search:"Search for name, group, ID or job",
            nui_players_id:"ID",
            nui_players_name:"Name",
            nui_players_group:"Group",
            nui_players_job:"Job",
            nui_players_bank:"Bank",
            nui_players_Penz:"Pénz",
            nui_players_kick:"Kick",
            nui_players_goto:"Goto",
            nui_players_bring:"Bring",
            nui_players_spectate:"Spectate",
        },
        presets: [
            {
                name: 'Blue',
                colors: {
                    '--primary': '#4361ee',
                    '--primary-dark': '#3a56d4',
                    '--secondary': '#3f37c9',
                    '--dark': '#1a1a2e',
                    '--darker': '#16213e',
                    '--light': '#f8f9fa',
                    '--danger': '#e63946',
                    '--success': '#2a9d8f',
                    '--warning': '#f4a261',
                    '--info': '#4cc9f0',
                    '--border-radius': '8px',
                    '--transition': 'all 0.2s ease'
                }
            },
            {
                name: 'Red',
                colors: {
                    '--primary': '#e63946',
                    '--primary-dark': '#d12d3a',
                    '--secondary': '#c9182a',
                    '--dark': '#2a0e11',
                    '--darker': '#1f0a0d',
                    '--light': '#f8f9fa',
                    '--danger': '#e63946',
                    '--success': '#2a9d8f',
                    '--warning': '#f4a261',
                    '--info': '#4cc9f0',
                    '--border-radius': '8px',
                    '--transition': 'all 0.2s ease'
                }
            },
            {
                name: 'Green',
                colors: {
                    '--primary': '#2a9d8f',
                    '--primary-dark': '#248d80',
                    '--secondary': '#1e7d72',
                    '--dark': '#0d2a26',
                    '--darker': '#081f1b',
                    '--light': '#f8f9fa',
                    '--danger': '#e63946',
                    '--success': '#2a9d8f',
                    '--warning': '#f4a261',
                    '--info': '#4cc9f0',
                    '--border-radius': '8px',
                    '--transition': 'all 0.2s ease'
                }
            },
            {
                name: 'Purple',
                colors: {
                    '--primary': '#7209b7',
                    '--primary-dark': '#6508a5',
                    '--secondary': '#5a0793',
                    '--dark': '#1e0a33',
                    '--darker': '#140625',
                    '--light': '#f8f9fa',
                    '--danger': '#e63946',
                    '--success': '#2a9d8f',
                    '--warning': '#f4a261',
                    '--info': '#4cc9f0',
                    '--border-radius': '8px',
                    '--transition': 'all 0.2s ease'
                }
            },
            {
                name: 'Orange',
                colors: {
                    '--primary': '#f4a261',
                    '--primary-dark': '#e69557',
                    '--secondary': '#d8884d',
                    '--dark': '#332011',
                    '--darker': '#26170b',
                    '--light': '#f8f9fa',
                    '--danger': '#e63946',
                    '--success': '#2a9d8f',
                    '--warning': '#f4a261',
                    '--info': '#4cc9f0',
                    '--border-radius': '8px',
                    '--transition': 'all 0.2s ease'
                }
            }
        ],
        search : "",
        searchTimeout: null
      }
    },
    computed: {
        filteredList() {
          if (!this.search.trim()) return this.players;
      
          const lowsearch = this.search.toLowerCase();
      
          return this.players.filter((player) => {
            return (
              player.name.toLowerCase().includes(lowsearch) ||
              (player.group && player.group.toLowerCase().includes(lowsearch)) ||
              (player.job && player.job.toLowerCase().includes(lowsearch)) ||
              player.id.toString().includes(lowsearch)
            );
          });
        }
    },
    watch: {
        search(newVal) {
          clearTimeout(this.searchTimeout);
          this.searchTimeout = setTimeout(() => {
            this.filteredList;
          }, 300);
        }
    },
    methods: {
        onMessage(event) {
            if (event.data.type == "show") {
                const appelement = document.getElementById("app");
                if (event.data.enable) {
                    this.opened = true;
                    appelement.style.animation = "hopin 0.4s";
                    appelement.style.display = "block";
                } else {
                    appelement.style.animation = "hopout 0.4s forwards"; 
                    this.opened = false;
                    setTimeout(() => {
                        appelement.style.display = "none";
                        appelement.style.top = "";
                        appelement.style.left = "";
                    }, 400);
                }
            } else if (event.data.type == "setplayers") {
                this.players = event.data.players;
            } 
            else if (event.data.type == "setstate") {
                this.state = event.data.state;
            }
            else if (event.data.type == "copy") {
                this.copytoclipboard(event.data.copy);
            }
        },
        copytoclipboard(txt) {
            var textArea = document.createElement("textarea");
            textArea.value = txt;
            document.body.appendChild(textArea);
            textArea.focus();
            textArea.select();
            document.execCommand('copy');
            document.body.removeChild(textArea);
        },
        spectate(id) {
            fetch(`https://${GetParentResourceName()}/spectate`, {
                method: 'POST',
                body: JSON.stringify({
                    id : id
                })
            });
            fetch(`https://${GetParentResourceName()}/exit`);
        },
        kick(id) {
            fetch(`https://${GetParentResourceName()}/kick`, {
                method: 'POST',
                body: JSON.stringify({
                    id : id
                })
            });
        },
        goto(id) {
            fetch(`https://${GetParentResourceName()}/goto`, {
                method: 'POST',
                body: JSON.stringify({
                    id : id
                })
            });
        },
        bring(id) {
            fetch(`https://${GetParentResourceName()}/bring`, {
                method: 'POST',
                body: JSON.stringify({
                    id : id
                })
            });
        },
        close() {
            fetch(`https://${GetParentResourceName()}/exit`);
        },
        update() {
            fetch(`https://${GetParentResourceName()}/update`);
        },
        duty() {
            this.state.duty = !this.state.duty
            fetch(`https://${GetParentResourceName()}/duty`, {
                method: 'POST',
                body: JSON.stringify({
                    enable : this.state.duty
                })
            });
        },
        tag() {
            if (!this.state.duty) return;

            this.state.tag = !this.state.tag
            fetch(`https://${GetParentResourceName()}/tag`, {
                method: 'POST',
                body: JSON.stringify({
                    enable : this.state.tag
                })
            });
        },
        ids() {
            if (!this.state.duty) return;
            this.state.ids = !this.state.ids
            fetch(`https://${GetParentResourceName()}/ids`, {
                method: 'POST',
                body: JSON.stringify({
                    enable : this.state.ids
                })
            });
        },
        god() {
            if (!this.state.duty) return;
            this.state.god = !this.state.god
            fetch(`https://${GetParentResourceName()}/god`, {
                method: 'POST',
                body: JSON.stringify({
                    enable : this.state.god
                })
            });
        },
        speed() {
            if (!this.state.duty) return;
            this.state.speed = !this.state.speed
            fetch(`https://${GetParentResourceName()}/speed`, {
                method: 'POST',
                body: JSON.stringify({
                    enable : this.state.speed
                })
            });
        },
        invisible() {
            if (!this.state.duty) return;
            this.state.invisible = !this.state.invisible
            fetch(`https://${GetParentResourceName()}/invisible`, {
                method: 'POST',
                body: JSON.stringify({
                    enable : this.state.invisible
                })
            });
        },
        adminzone() {
            if (!this.state.duty) return;
            this.state.adminzone = !this.state.adminzone
            fetch(`https://${GetParentResourceName()}/adminzone`, {
                method: 'POST',
                body: JSON.stringify({
                    enable : this.state.adminzone
                })
            });
        },
        noragdoll() {
            if (!this.state.duty) return;
            this.state.noragdoll = !this.state.noragdoll
            fetch(`https://${GetParentResourceName()}/noragdoll`, {
                method: 'POST',
                body: JSON.stringify({
                    enable : this.state.noragdoll
                })
            });
        },
        coords() {
            if (!this.state.duty) return;
            fetch(`https://${GetParentResourceName()}/coords`);
        },
        heal() {
            if (!this.state.duty) return;
            fetch(`https://${GetParentResourceName()}/heal`);
        },
        marker() {
            if (!this.state.duty) return;
            fetch(`https://${GetParentResourceName()}/marker`);
        },
        updateColor(varName, value) {
            document.documentElement.style.setProperty(varName, value);
            this.colorVars[varName] = value;
        },
        applyPreset(colors) {
            const elementsWithStyles = [
              { element: document.querySelector('.app-header'), style: 'all' },
            ];
            
            const glowColor = colors['--primary'] || '#646cff';
            document.documentElement.style.setProperty('--glow-color', glowColor);
            
            elementsWithStyles.forEach(item => {
              if (item.element) {
                item.element.dataset.originalBorder = item.element.style.border;
                
                if (item.style === 'right') {
                  item.element.style.borderRight = `1px solid ${glowColor}`;
                  item.element.classList.add('border-glow-right-transition');
                } else {
                  item.element.classList.add('border-glow-transition');
                }
              }
            });
            
            setTimeout(() => {
              Object.keys(colors).forEach(key => {
                this.colorVars[key] = colors[key];
                this.updateColor(key, colors[key]);
              });
              
              setTimeout(() => {
                elementsWithStyles.forEach(item => {
                  if (item.element) {
                    if (item.style === 'right') {
                      item.element.classList.remove('border-glow-right-transition');
                      item.element.style.borderRight = '';
                    } else {
                      item.element.classList.remove('border-glow-transition');
                      item.element.style.border = '';
                    }
                  }
                });
              }, 2000);
            }, 100);
          },
        loadColors() {
            const savedColors = localStorage.getItem('themeColors');
            if (savedColors) {
                try {
                    const parsedColors = JSON.parse(savedColors);
                    this.applyPreset(parsedColors);
                } catch (e) {
                    console.error('Error parsing saved colors:', e);
                    this.applyPreset(this.presets[0].colors);
                }
            } else {
                this.applyPreset(this.presets[0].colors);
            }
        },
        dragElement(elmnt) {
            var pos1 = 0, pos2 = 0, pos3 = 0, pos4 = 0;
            if (document.getElementById(elmnt.id + "-header")) {
              document.getElementById(elmnt.id + "-header").onmousedown = dragMouseDown;
            } else {
              elmnt.onmousedown = dragMouseDown;
            }
          
            function dragMouseDown(e) {
              e = e || window.event;
              e.preventDefault();
              pos3 = e.clientX;
              pos4 = e.clientY;
              document.onmouseup = closeDragElement;
              document.onmousemove = elementDrag;
            }
          
            function elementDrag(e) {
              e = e || window.event;
              e.preventDefault();
              pos1 = pos3 - e.clientX;
              pos2 = pos4 - e.clientY;
              pos3 = e.clientX;
              pos4 = e.clientY;
              elmnt.style.top = (elmnt.offsetTop - pos2) + "px";
              elmnt.style.left = (elmnt.offsetLeft - pos1) + "px";
            }
          
            function closeDragElement() {
              document.onmouseup = null;
              document.onmousemove = null;
            }
          },
    }, 
    
    async mounted() {
        window.addEventListener('message', this.onMessage);
        var response = await fetch(`https://${GetParentResourceName()}/locales`);
        var locales = await response.json();
        this.locales = locales;
        this.dragElement(document.getElementById("app"));
    }
}).mount('#app');

document.addEventListener('keydown', (event) => {
    if (event.key === "Escape") { 
        fetch(`https://${GetParentResourceName()}/exit`);
    }
});

