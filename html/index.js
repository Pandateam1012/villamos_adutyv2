const App = Vue.createApp({
    data() {
      return {
        opened : false,
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

    }, 
    
    async mounted() {
        window.addEventListener('message', this.onMessage);
        var response = await fetch(`https://${GetParentResourceName()}/locales`);
        var locales = await response.json();
        this.locales = locales;
    }
}).mount('#app');

document.addEventListener('keydown', (event) => {
    if (event.key === "Escape") { 
        fetch(`https://${GetParentResourceName()}/exit`);
    }
});

var elmnt = document.getElementById("app");
var pos1 = 0, pos2 = 0, pos3 = 0, pos4 = 0;
if (document.getElementById("appheader")) {
    document.getElementById("appheader").onmousedown = dragMouseDown;
} else {
    elmnt.onmousedown = dragMouseDown;
}


function dragMouseDown(e) {
    if (e.target.id !== "appheader") return;
    
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
