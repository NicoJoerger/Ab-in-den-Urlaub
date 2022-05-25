using System;
using System.Collections.Generic;

namespace AbInDenUrlaub
{
    public partial class Ferienwohnung
    {
        public Ferienwohnung()
        {
            Angebotes = new HashSet<Angebote>();
            Bewertungs = new HashSet<Bewertung>();
            Wohnungsbilders = new HashSet<Wohnungsbilder>();
        }

        public int FwId { get; set; }
        public int? UserId { get; set; }
        public string Strasse { get; set; } = null!;
        public int hausnummer { get; set; } 
        public string Ort { get; set; } = null!;
        public int Plz { get; set; }
        public int Wohnflaeche { get; set; }
        public int Anzzimmer { get; set; }
        public int Anzbetten { get; set; }
        public int Anzbaeder { get; set; }
        public bool Wifi { get; set; }
        public bool Garten { get; set; }
        public bool Balkon { get; set; }
        public string? Beschreibung { get; set; }
        public string wohnungsname { get; set; }

        public virtual Nutzer? User { get; set; }
        public virtual ICollection<Angebote> Angebotes { get; set; }
        public virtual ICollection<Bewertung> Bewertungs { get; set; }
        public virtual ICollection<Wohnungsbilder> Wohnungsbilders { get; set; }
    }
}
