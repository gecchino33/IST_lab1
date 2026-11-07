
math coord.ucs 



line x location= 0.0      spacing= 1.0<nm>  tag= SiTop        
line x location= 50.0<nm> spacing= 10.0<nm>                    
line x location= 0.5<um>  spacing= 50.0<nm>                      
line x location= 2.0<um>  spacing= 0.2<um>                       
line x location= 4.0<um>  spacing= 0.4<um>                       
line x location= 10.0<um> spacing= 2.0<um>  tag= SiBottom   

line y location= 0.0      spacing= 50.0<nm> tag= Mid         
line y location= 0.40<um> spacing=50.0<nm>  tag= Right       



region Silicon xlo= SiTop xhi= SiBottom ylo= Mid yhi= Right



init concentration= 1.0e+15<cm-3> field= Phosphorus !DelayFullD

AdvancedCalibration 




implant  Boron  dose= 2.0e13<cm-2>  energy= 200<keV> tilt= 0 rotation= 0 
SetPlxList   {BTotal}
WritePlx n1_NMOS_pwell1.plx  y=0.0 Silicon

implant  Boron  dose= 1.0e13<cm-2>  energy= 80<keV> tilt= 0 rotation= 0  
SetPlxList   {BTotal}
WritePlx n1_NMOS_pwell2.plx  y=0.0 Silicon

implant  Boron  dose= 2.0e12<cm-2>  energy= 25<keV> tilt= 0 rotation= 0  
SetPlxList   {BTotal}
WritePlx n1_NMOS_pwell3.plx  y=0.0 Silicon

diffuse temperature= 1050<C> time= 10.0<s>   
SetPlxList   {BTotal}
WritePlx n1_NMOS_substrate1.plx  y=0.0 Silicon


grid set.min.normal.size= 1<nm> set.normal.growth.ratio.2d= 1.5
mgoals accuracy= 1e-5



diffuse temperature= 850<C> time= 10.0<min> O2





deposit material= {PolySilicon} type= anisotropic time= 1 rate= {0.18}



mask name= gate_mask left=-1 right= 90<nm>

etch material= {PolySilicon} type= anisotropic time= 1 rate= {0.2} \
  mask= gate_mask


etch material= {Oxide}       type= anisotropic time= 1 rate= {0.03}



diffuse temperature= 900<C> time= 10.0<min>  O2 

struct tdr= n1_Polysilicon_reOxidation ; # Poly Reox




refinebox Silicon min= {0.0 0.05} max= {0.1 0.12} xrefine= {0.01 0.01 0.01} \
                                                  yrefine= {0.01 0.01 0.01} add
grid remesh

implant Arsenic dose= 4e14<cm-2> energy= 10<keV> tilt= 0 rotation= 0

struct tdr= n1_LDD_Implant_Arsenic ; # LDD Implant

diffuse temperature= 1050<C> time= 0.1<s> ; # Quick activation

struct tdr= n1_LDD_Diffuse_Arsenic_Activation ; # LDD Diffuse


implant Boron dose= 0.25e13<cm-2> energy= 20<keV> tilt= 30<degree> \
rotation= 0

struct tdr= n1_Halo_1 ; # Halo 1

implant Boron dose= 0.25e13<cm-2> energy= 20<keV> tilt= 30<degree> \
rotation= 90<degree>

struct tdr= n1_Halo_2 ; # Halo 2

implant Boron dose= 0.25e13<cm-2> energy= 20<keV> tilt= 30<degree> \
rotation= 180<degree>

struct tdr= n1_Halo_3 ; # Halo 3

implant Boron dose= 0.25e13<cm-2> energy= 20<keV> tilt= 30<degree> \
rotation= 270<degree>

struct tdr= n1_Halo_4 ; # Halo 4


diffuse temperature= 1050<C> time= 5.0<s>

struct tdr= n1_RTA_LDD_HALO ; # Halo RTA



deposit material= {Nitride} type= isotropic  time= 1 rate= {0.06}

struct tdr= n1_Spacer_deposition ; # Spacer deposition

etch    material= {Nitride} type= anisotropic time = 1 rate= {0.084} \
				isotropic.overetch= 0.01

struct tdr= n1_Spacer_etch ; # Spacer etch				
				
etch    material= {Oxide}   type= anisotropic time= 1 rate= {0.01} 

struct tdr= n1_Spacer_oxide_removal ; # Spacer oxide removal




refinebox Silicon min= {0.04 0.12} max= {0.1 0.12} xrefine= {0.01 0.01 0.01} \
                                                  yrefine= {0.05 0.05 0.05} add
grid remesh


implant Arsenic dose= 5e15<cm-2> energy= 40<keV> \
        tilt= 7<degree> rotation= -90<degree> 

struct tdr= n1_SD_IMPLANT_As_implantation ; # N+ implantation


diffuse temperature= 1050<C> time= 10.0<s> 

struct tdr= n1_SD_IMPLANT_As_activation ; # Final RTA



deposit material= {Aluminum} type= isotropic time= 1 rate= {0.03}

struct tdr= n1_DEP_CONTACTS_Aluminium_deposition ; # Aluminium deposition

mask name= contacts_mask left= 0.2<um> right= 1.0<um>
etch material= {Aluminum} type= anisotropic time= 1 rate= {0.25} \
     mask= contacts_mask
     
struct tdr= n1_DEP_CONTACTS_Aluminium_etchin_1 ; # Aluminium etching 1   

mask name= gate_mask2 left=-1 right= 80<nm> negative
deposit material= {Aluminum} type= anisotropic time= 1 rate= {0.03} \
     mask= gate_mask2 

struct tdr= n1_NMOS18 ; # Gate contact creation



transform reflect left 



struct tdr= n1_NMOS20 ; # Final

SetPlxList   {BTotal NetActive}
WritePlx n1_NMOS_channel.plx  y=0.0 Silicon

SetPlxList   {AsTotal BTotal NetActive}
WritePlx n1_NMOS_ldd.plx y=0.1 Silicon

SetPlxList   {AsTotal BTotal NetActive}
WritePlx n1_NMOS_sd.plx y=0.39 Silicon


	
contact bottom name = substrate Silicon

contact name = gate x = -0.2 y = 0.0 Aluminum

contact name = source x = -0.027 y = -0.3 Aluminum

contact name = drain x = -0.027 y = 0.3 Aluminum

struct tdr= n1_presimulation


exit










