const App = Vue.createApp({
    data() {
        return {
            opened: false,
            players: [
                { id: 1, name: "6osvillamos", group: "admin", job: "Rendőr" },
                { id: 1, name: "Pandateam", group: "Dev", job: "Szerelő" },
                { id: 1, name: "Bandi", group: "Dev", job: "Dikpik" },
            ],
            state: {
                group: "user",
                duty: false,
                tag: false,
                ids: false,
                god: false,
                speed: false,
                invisible: false,
                noragdoll: false
            },
            locales: {
                nui_label: "ADMIN DUTY PANEL",
                nui_group: "Your group",
                nui_players: "Players",
                nui_duty: "Duty",
                nui_tag: "Admin tag",
                nui_esp: "Show IDs",
                nui_god: "God mode",
                nui_speed: "Speed",
                nui_invisble: "Invisible",
                nui_noragdoll: "No Ragdoll",
                nui_coords: "Coords",
                nui_health: "Health",
                nui_marker: "Marker",
                nui_label_players: "PLAYERS",
                nui_players_refresh: "Refresh",
                nui_players_search: "Search for name, group, ID or job",
                nui_players_id: "ID",
                nui_players_name: "Name",
                nui_players_group: "Group",
                nui_players_job: "Job",
                nui_goto: "Goto",
                nui_bring: 'Bring',
                nui_Admin: 'Clothing Menu',
                nui_Spectate: 'Spectate',
                nui_Kick: 'Kick',
                nui_anauncement: 'Announcement',
                nui_noclip: 'Noclip',
                nui_specmenu: 'Spectate Menu',
                nui_punishment: 'Punishment'
            },
            search: ""
        }
    },
    computed: {
        filteredList() {
            if (this.search == "") return this.players;

            const lowsearch = this.search.toLowerCase()

            return this.players.filter((player) => {
                return player.name.toLowerCase().includes(lowsearch) || player.group.toLowerCase() == lowsearch || player.job.toLowerCase() == lowsearch || player.id.toString() == lowsearch;
            });
        }
    },
    methods: {
        onMessage(event) {
            if (event.data.type == "show") {
                const appelement = document.getElementById("app");
                if (event.data.enable) {
                    appelement.style.display = "block";
                    appelement.style.animation = "hopin 0.7s";
                    this.opened = true;
                } else {
                    appelement.style.animation = "hopout 0.6s";
                    this.opened = false;
                    setTimeout(() => {
                        if (!this.opened) appelement.style.display = "none";
                    }, 500);
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
        playerSelected() {
            let playerId = document.getElementById('id').value
            fetch(`https://${GetParentResourceName()}/playerSelected`, {
                method: 'POST',
                body: JSON.stringify({
                    id: playerId
                })
            });
        },
        close() {
            fetch(`https://${GetParentResourceName()}/exit`);
            document.getElementById("clothmenu").style.display = 'none';
        },
        update() {
            fetch(`https://${GetParentResourceName()}/update`);
        },
        duty() {
            this.state.duty = !this.state.duty
            fetch(`https://${GetParentResourceName()}/duty`, {
                method: 'POST',
                body: JSON.stringify({
                    enable: this.state.duty
                })
            });
        },
        tag() {
            this.state.tag = !this.state.tag
            fetch(`https://${GetParentResourceName()}/tag`, {
                method: 'POST',
                body: JSON.stringify({
                    enable: this.state.tag
                })
            });
        },
        ids() {
            this.state.ids = !this.state.ids
            fetch(`https://${GetParentResourceName()}/ids`, {
                method: 'POST',
                body: JSON.stringify({
                    enable: this.state.ids
                })
            });
        },
        god() {
            this.state.god = !this.state.god
            fetch(`https://${GetParentResourceName()}/god`, {
                method: 'POST',
                body: JSON.stringify({
                    enable: this.state.god
                })
            });
        },
        speed() {
            this.state.speed = !this.state.speed
            fetch(`https://${GetParentResourceName()}/speed`, {
                method: 'POST',
                body: JSON.stringify({
                    enable: this.state.speed
                })
            });
        },
        invisible() {
            this.state.invisible = !this.state.invisible
            fetch(`https://${GetParentResourceName()}/invisible`, {
                method: 'POST',
                body: JSON.stringify({
                    enable: this.state.invisible
                })
            });
        },
        noragdoll() {
            this.state.noragdoll = !this.state.noragdoll
            fetch(`https://${GetParentResourceName()}/noragdoll`, {
                method: 'POST',
                body: JSON.stringify({
                    enable: this.state.noragdoll
                })
            });
        },
        noclip() {
            this.state.noclip = !this.state.noclip
            fetch(`https://${GetParentResourceName()}/noclip`, {
                method: 'POST',
                body: JSON.stringify({
                    enable: this.state.noclip
                })
            });
        },
        coords() {
            fetch(`https://${GetParentResourceName()}/coords`);
        },
        heal() {
            fetch(`https://${GetParentResourceName()}/heal`);
        },
        marker() {
            fetch(`https://${GetParentResourceName()}/marker`);
        },
        anon() {
            fetch(`https://${GetParentResourceName()}/sendanon`);
        },
        opespec() {
            fetch(`https://${GetParentResourceName()}/opespec`);
        },
        punishment() {
            fetch(`https://${GetParentResourceName()}/punishment`);
        },
        gotoplayer(playerId) {
            fetch(`https://${GetParentResourceName()}/goto`, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                },
                body: JSON.stringify({
                    playerId: playerId
                })
            })
        },
        kickplayer(playerId) {
            fetch(`https://${GetParentResourceName()}/kick`, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                },
                body: JSON.stringify({
                    playerId: playerId
                })
            })
        },
        bringplayer(playerId) {
            fetch(`https://${GetParentResourceName()}/bring`, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                },
                body: JSON.stringify({
                    playerId: playerId
                })
            })
        },
        specplayer(playerId) {
            fetch(`https://${GetParentResourceName()}/spectate`, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                },
                body: JSON.stringify({
                    playerId: playerId
                })
            })
        },
    },
    async mounted() {
        window.addEventListener('message', this.onMessage);
        var response = await fetch(`https://${GetParentResourceName()}/locales`);
        var locales = await response.json();
        this.locales = locales;
    }
}).mount('#app');

const Cloth = Vue.createApp({
    data() {
        return {
            opened: false,
            state: {
                ruha: false,
                white: false,
                orang: false,
                pink: false,
                red: false,
                gren: false,
                yelw: false
            },
            locales: {
                nui_clothing_menu: "Clothing Menu",
                nui_whitecloth: "White Cloth",
                nui_orangcloth: "Orang Cloth",
                nui_pinkcloth: "Pink Cloth",
                nui_redcloth: "Red Cloth",
                nui_grencloth: "Green Cloth",
                nui_yelkwcloth: "Yellow Cloth",
                nui_changecloth: "Change Clothing",
                nui_Admin: "Admin Clothing",
            },
        }
    },
    methods: {
        resetAll() {
            this.state.ruha = false;
            this.state.white = false;
            this.state.orang = false;
            this.state.pink = false;
            this.state.red = false;
            this.state.gren = false;
            this.state.yelw = false;
        },
        white() {
            if (!this.state.white) {
                this.resetAll(); 
                this.state.white = true;
            } else {
                this.state.white = false;
            }
            fetch(`https://${GetParentResourceName()}/white`, {
                method: 'POST',
                body: JSON.stringify({
                    enable: this.state.white
                })
            });
        },
        orang() {
            if (!this.state.orang) {
                this.resetAll(); 
                this.state.orang = true;
            } else {
                this.state.orang = false;
            }
            fetch(`https://${GetParentResourceName()}/orang`, {
                method: 'POST',
                body: JSON.stringify({
                    enable: this.state.orang
                })
            });
        },
        pink() {
            if (!this.state.pink) {
                this.resetAll();  
                this.state.pink = true;
            } else {
                this.state.pink = false;
            }
            fetch(`https://${GetParentResourceName()}/pink`, {
                method: 'POST',
                body: JSON.stringify({
                    enable: this.state.pink
                })
            });
        },
        red() {
            if (!this.state.red) {
                this.resetAll();  
                this.state.red = true;
            } else {
                this.state.red = false;
            }
            fetch(`https://${GetParentResourceName()}/red`, {
                method: 'POST',
                body: JSON.stringify({
                    enable: this.state.red
                })
            });
        },
        gren() {
            if (!this.state.gren) {
                this.resetAll();  
                this.state.gren = true;
            } else {
                this.state.gren = false;
            }
            fetch(`https://${GetParentResourceName()}/gren`, {
                method: 'POST',
                body: JSON.stringify({
                    enable: this.state.gren
                })
            });
        },
        yelw() {
            if (!this.state.yelw) {
                this.resetAll();  
                this.state.yelw = true;
            } else {
                this.state.yelw = false;
            }
            fetch(`https://${GetParentResourceName()}/yelw`, {
                method: 'POST',
                body: JSON.stringify({
                    enable: this.state.yelw
                })
            });
        },
        bezar() {
            document.getElementById("clothmenu").style.animation = "hopout 1s";
            setTimeout(() => {
                document.getElementById("clothmenu").style.display = "none"
            }, 800);
        },
    },
    async mounted() {
        window.addEventListener('message', this.onMessage);
        var response = await fetch(`https://${GetParentResourceName()}/locales`);
        var locales = await response.json();
        this.locales = locales;
    }
}).mount('#clothmenu');

function clothing() {
    document.getElementById("clothmenu").style.display = "block"
}


function spec(){
    document.getElementById("clothmenu").style.animation = "hopout 1s";
    document.getElementById("app").style.animation = "hopout 1s";
    setTimeout(() => {
        fetch(`https://${GetParentResourceName()}/exit`);
    }, 800);
}

function makeDraggable(element, handle) {
    var pos1 = 0, pos2 = 0, pos3 = 0, pos4 = 0;

    handle.onmousedown = dragMouseDown;

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
        element.style.top = (element.offsetTop - pos2) + "px";
        element.style.left = (element.offsetLeft - pos1) + "px";
    }

    function closeDragElement() {
        document.onmouseup = null;
        document.onmousemove = null;
    }
}

makeDraggable(document.getElementById("app"), document.getElementById("appheader"));
makeDraggable(document.getElementById("clothmenu"), document.getElementById("clothheader"));
