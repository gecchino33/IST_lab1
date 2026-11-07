# 2D nMOSFET (0.18um technology)
# ------------------------------

#è una libreria
math coord.ucs 


# Declare initial grid (half structure)
# -------------------------------------

# asse verticale
line x location= 0.0      spacing= 1.0<nm>  tag= SiTop        
line x location= 50.0<nm> spacing= 10.0<nm>                    
line x location= 0.5<um>  spacing= 50.0<nm>                      
line x location= 2.0<um>  spacing= 0.2<um>                       
line x location= 4.0<um>  spacing= 0.4<um>                       
line x location= 10.0<um> spacing= 2.0<um>  tag= SiBottom   

#asse profondità
#la coordinata y=0 è il centro della struttura
line y location= 0.0      spacing= 50.0<nm> tag= Mid         
line y location= 0.40<um> spacing=50.0<nm>  tag= Right       


# Silicon substrate definition
# ----------------------------

region Silicon xlo= SiTop xhi= SiBottom ylo= Mid yhi= Right


# Initialize the simulation
# -------------------------

init concentration= 1.0e+15<cm-3> field= Phosphorus !DelayFullD

AdvancedCalibration 

#struct tdr=n@node@_NMOS_substrate0; #substrate

#BORON IMPLANTATION

# p-well, anti-punchthrough & Vt adjustment implants
# --------------------------------------------------

implant  Boron  dose= 2.0e13<cm-2>  energy= 200<keV> tilt= 0 rotation= 0 
SetPlxList   {BTotal}
WritePlx n@node@_NMOS_pwell1.plx  y=0.0 Silicon
#struct tdr=n@node@_NMOS_pwell1; 

implant  Boron  dose= 1.0e13<cm-2>  energy= 80<keV> tilt= 0 rotation= 0  
SetPlxList   {BTotal}
WritePlx n@node@_NMOS_pwell2.plx  y=0.0 Silicon
#struct tdr=n@node@_NMOS_pwell2; 

implant  Boron  dose= 2.0e12<cm-2>  energy= 25<keV> tilt= 0 rotation= 0  
SetPlxList   {BTotal}
WritePlx n@node@_NMOS_pwell3.plx  y=0.0 Silicon
#struct tdr=n@node@_NMOS_pwell3;

diffuse temperature= 1050<C> time= 10.0<s>   
SetPlxList   {BTotal}
WritePlx n@node@_NMOS_substrate1.plx  y=0.0 Silicon
#struct tdr=n@node@_NMOS_substrate1; #substrate with pwell

# Global Mesh settings for automatic meshing in newly generated layers
# --------------------------------------------------------------------

grid set.min.normal.size= 1<nm> set.normal.growth.ratio.2d= 1.5
mgoals accuracy= 1e-5

#pdbSet Oxide Grid perp.add.dist 1e-7
#pdbSet Grid NativeLayerThickness 1e-7

# Gate oxidation
# --------------

diffuse temperature= 850<C> time= 10.0<min> O2

#struct tdr=n@node@_NMOS_gate_oxide_growth; #oxidation

##### misurazione substrato con righello dx= 0.00328035 um

# GATE CREATION

# Poly gate deposition
# --------------------

deposit material= {PolySilicon} type= anisotropic time= 1 rate= {0.18}


# Poly gate pattern/etch
# ----------------------

mask name= gate_mask left=-1 right= 90<nm>

etch material= {PolySilicon} type= anisotropic time= 1 rate= {0.2} \
  mask= gate_mask

#struct tdr= n@node@_Gate_Creation_etching_poly;

etch material= {Oxide}       type= anisotropic time= 1 rate= {0.03}

#struct tdr= n@node@_Gate_Creation_etching_oxide; # PolyGate

# Poly reoxidation
# ----------------

diffuse temperature= 900<C> time= 10.0<min>  O2 

struct tdr= n@node@_Polysilicon_reOxidation ; # Poly Reox


# LDD implantation
# ----------------

# mesh più accurata nella regione indicate (sotto tra gate e n+-region)

refinebox Silicon min= {0.0 0.05} max= {0.1 0.12} xrefine= {0.01 0.01 0.01} \
                                                  yrefine= {0.01 0.01 0.01} add
grid remesh

implant Arsenic dose= 4e14<cm-2> energy= 10<keV> tilt= 0 rotation= 0

struct tdr= n@node@_LDD_Implant_Arsenic ; # LDD Implant

diffuse temperature= 1050<C> time= 0.1<s> ; # Quick activation

struct tdr= n@node@_LDD_Diffuse_Arsenic_Activation ; # LDD Diffuse

# Halo implantation: Quad HALO implants
# -------------------------------------

implant Boron dose= 0.25e13<cm-2> energy= 20<keV> tilt= 30<degree> \
rotation= 0

struct tdr= n@node@_Halo_1 ; # Halo 1

implant Boron dose= 0.25e13<cm-2> energy= 20<keV> tilt= 30<degree> \
rotation= 90<degree>

struct tdr= n@node@_Halo_2 ; # Halo 2

implant Boron dose= 0.25e13<cm-2> energy= 20<keV> tilt= 30<degree> \
rotation= 180<degree>

struct tdr= n@node@_Halo_3 ; # Halo 3

implant Boron dose= 0.25e13<cm-2> energy= 20<keV> tilt= 30<degree> \
rotation= 270<degree>

struct tdr= n@node@_Halo_4 ; # Halo 4

# RTA of LDD/HALO implants
# ------------------------

diffuse temperature= 1050<C> time= 5.0<s>

struct tdr= n@node@_RTA_LDD_HALO ; # Halo RTA


# Nitride spacer
# --------------

deposit material= {Nitride} type= isotropic  time= 1 rate= {0.06}

struct tdr= n@node@_Spacer_deposition ; # Spacer deposition

etch    material= {Nitride} type= anisotropic time = 1 rate= {0.084} \
				isotropic.overetch= 0.01

struct tdr= n@node@_Spacer_etch ; # Spacer etch				
				
etch    material= {Oxide}   type= anisotropic time= 1 rate= {0.01} 

struct tdr= n@node@_Spacer_oxide_removal ; # Spacer oxide removal

# SOURCE/DRAIN IMPLANTATION

# N+ implantation
# ---------------

# la grid seleziona gli spigoli del rettangolo top-left bottom-right nelle prime graffe
# refine stabiliamo la risoluzione della nuova griglia

refinebox Silicon min= {0.04 0.12} max= {0.1 0.12} xrefine= {0.01 0.01 0.01} \
                                                  yrefine= {0.05 0.05 0.05} add
grid remesh


# ---------------------------------------------------------#
implant Arsenic dose= 5e15<cm-2> energy= 40<keV> \
        tilt= 7<degree> rotation= -90<degree> 

struct tdr= n@node@_SD_IMPLANT_As_implantation ; # N+ implantation

# Final RTA
# ---------------------------

diffuse temperature= 1050<C> time= 10.0<s> 

struct tdr= n@node@_SD_IMPLANT_As_activation ; # Final RTA

# DEPOSITION OF CONTACTS PADS

# Contacts
# --------

deposit material= {Aluminum} type= isotropic time= 1 rate= {0.03}

struct tdr= n@node@_DEP_CONTACTS_Aluminium_deposition ; # Aluminium deposition

mask name= contacts_mask left= 0.2<um> right= 1.0<um>
etch material= {Aluminum} type= anisotropic time= 1 rate= {0.25} \
     mask= contacts_mask
     
struct tdr= n@node@_DEP_CONTACTS_Aluminium_etchin_1 ; # Aluminium etching 1   

mask name= gate_mask2 left=-1 right= 80<nm> negative
deposit material= {Aluminum} type= anisotropic time= 1 rate= {0.03} \
     mask= gate_mask2 

struct tdr= n@node@_NMOS18 ; # Gate contact creation


# Reflect
# -------

transform reflect left 


# save final structure:
#  - 1D cross sections

struct tdr= n@node@_NMOS20 ; # Final

SetPlxList   {BTotal NetActive}
WritePlx n@node@_NMOS_channel.plx  y=0.0 Silicon

SetPlxList   {AsTotal BTotal NetActive}
WritePlx n@node@_NMOS_ldd.plx y=0.1 Silicon

SetPlxList   {AsTotal BTotal NetActive}
WritePlx n@node@_NMOS_sd.plx y=0.39 Silicon


# Contacts
# -------
	
contact bottom name = substrate Silicon

contact name = gate x = -0.2 y = 0.0 Aluminum

contact name = source x = -0.027 y = -0.3 Aluminum

contact name = drain x = -0.027 y = 0.3 Aluminum

struct tdr= n@node@_presimulation


exit









