# 📖 Sistema Descrizioni Item - Guida Utilizzo

## ✅ Sistema Creato

Ho creato un **Item Description Manager** completo e ben organizzato per gestire tutte le descrizioni degli oggetti del gioco.

### 🗂️ **File Creati:**
- `objects/obj_item_description_manager/obj_item_description_manager.yy`
- `objects/obj_item_description_manager/Create_0.gml`

### 🎯 **Caratteristiche:**

#### **📊 Struttura Dati Organizzata**
```gml
global.item_descriptions = {
    "spr_axe": {
        name: "Ascia",
        description: "Un'ascia affilata per tagliare alberi...",
        category: "tool",
        rarity: "common"
    },
    // ... altri item
}
```

#### **🏷️ Categorie Item**
- **tool**: Attrezzi (ascia, piccone, zappa, canna da pesca)
- **seed**: Semi (pomodoro, carota)
- **crop**: Verdure raccolte (melanzana, granturco, cetriolo, ecc.)
- **resource**: Risorse (legno, bronzo)

#### **💎 Rarità Item**
- **common**: Bianco
- **uncommon**: Verde lime
- **rare**: Ciano
- **epic**: Viola
- **legendary**: Arancione

## 🔧 **Funzioni Disponibili**

### **Funzioni Principali:**
```gml
get_item_description(sprite_or_name)     // Ottiene struct completo
get_item_name(sprite_or_name)            // Ottiene solo il nome
get_item_description_text(sprite_or_name) // Ottiene solo la descrizione
get_item_category(sprite_or_name)        // Ottiene la categoria
get_item_rarity(sprite_or_name)          // Ottiene la rarità
get_rarity_color(rarity)                 // Ottiene colore rarità
```

### **Funzione per Aggiungere Item:**
```gml
add_item_description(sprite_name, name, description, category, rarity, extra_data)
```

## 📝 **Item Già Configurati:**

### **🔨 Attrezzi:**
- Ascia, Piccone, Zappa, Canna da Pesca

### **🌱 Semi:**
- Semi di Pomodoro, Semi di Carota

### **🥕 Verdure:**
- Melanzana, Granturco, Cetriolo, Aglio, Lattuga, Cipolla, Peperone, Patata, Zucca

### **📦 Risorse:**
- Legno, Bronzo

## 🆕 **Come Aggiungere Nuovi Item:**

### **Metodo 1: Nel Create_0.gml**
Aggiungi direttamente nella sezione appropriata:
```gml
global.item_descriptions[$ sprite_get_name(spr_nuovo_item)] = {
    name: "Nome Item",
    description: "Descrizione dettagliata...",
    category: "tool", // o "seed", "crop", "resource"
    rarity: "common"  // o "uncommon", "rare", "epic", "legendary"
};
```

### **Metodo 2: Via Codice**
Usa la funzione helper:
```gml
add_item_description("spr_nuovo_item", "Nome Item", "Descrizione...", "tool", "common");
```

### **Metodo 3: Con Dati Extra**
Per item speciali con proprietà aggiuntive:
```gml
add_item_description("spr_seed_speciale", "Seme Magico", "Un seme che...", "seed", "rare", {
    grow_time: "2 giorni",
    season: "Inverno",
    special_effect: "Glow al buio"
});
```

## 🎨 **Cosa Devi Fare Manualmente nell'Editor:**

### **⚠️ IMPORTANTE - Aggiungi all'Editor:**
1. **Apri GameMaker Studio**
2. **Vai nella cartella Objects/Managers**
3. **Aggiungi obj_item_description_manager** alla lista oggetti del progetto
4. **Il sistema è già configurato nelle room!**

Il manager è già stato aggiunto automaticamente in:
- Room1
- rm_interior

## 🚀 **Esempi d'Uso:**

```gml
// Ottieni nome item
var nome = get_item_name(spr_axe); // "Ascia"

// Ottieni descrizione completa
var desc = get_item_description_text(spr_tomato); // "Semi freschi di pomodoro..."

// Ottieni colore rarità
var colore = get_rarity_color("epic"); // c_purple

// Controlla categoria
if (get_item_category(mio_sprite) == "tool") {
    // È un attrezzo
}
```

Il sistema è **completamente funzionale** e **facilmente espandibile**! 🎉