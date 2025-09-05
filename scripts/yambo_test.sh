#从这个教程开始，可以一步步较为顺畅的测试和使用Yambo
#https://wiki.yambo-code.eu/wiki/index.php?title=Bulk_material:_h-BN
#返回first step后，接续这个
#https://wiki.yambo-code.eu/wiki/index.php?title=Optics_at_the_independent_particle_level


####测试
wget https://media.yambo-code.eu/educational/tutorials/files/hBN.tar.gz
tar -xzf hBN.tar.gz
cd hBN/PWSCF
#
pw.x < hBN_scf.in > hBN_scf.out
pw.x < hBN_nscf.in > hBN_nscf.out
#
cd hBN.save
p2y
yambo -D
#


###使用说明，接后续步骤
#cd ../../YAMBO
#yambo
#






#wget https://media.yambo-code.eu/educational/tutorials/files/LiF.tar.gz
#tar -xzf LiF.tar.gz
#cd LiF/PWSCF
#pw.x < inputs/scf.in > scf.out
#pw.x < inputs/nscf.in > nscf.out  

