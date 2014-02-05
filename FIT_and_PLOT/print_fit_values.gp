t1=268
set print "./FIT_VALUES/T_wc_a_wc0_".dataname."".datatimerange."".dataregion.".dat"
print t1+1, (2.5/a269)+wc0269, a269, wc0269
print t1+2, (2.5/a270)+wc0270, a270, wc0270
print t1+3, (2.5/a271)+wc0271, a271, wc0271
print t1+4, (2.5/a272)+wc0272, a272, wc0272
print t1+5, (2.5/a273)+wc0273, a273, wc0273
print t1+6, (2.5/a274)+wc0274, a274, wc0274

set print "-"

set print "./FIT_VALUES/T_wc_a_wc0_".dataname."".datatimerange."".dataregion.".gp"
print "wc269=",(2.5/a269)+wc0269
print "wc270=",(2.5/a270)+wc0270
print "wc271=",(2.5/a271)+wc0271
print "wc272=",(2.5/a272)+wc0272
print "wc273=",(2.5/a273)+wc0273
print "wc274=",(2.5/a274)+wc0274
print "wc0269=",wc0269
print "a269=",a269
print "wc0270=",wc0270
print "a270=",a270
print "wc0271=",wc0271
print "a271=",a271
print "wc0272=",wc0272
print "a272=",a272
print "wc0273=",wc0273
print "a273=",a273
print "wc0274=",wc0274
print "a274=",a274

print "wc269Pmin=", 2.5/a269 + wc0269
print "wc269Pmax=", 6.0/a269 + wc0269
print "wc270Pmin=", 2.5/a270 + wc0270
print "wc270Pmax=", 6.0/a270 + wc0270
print "wc271Pmin=", 2.5/a271 + wc0271
print "wc271Pmax=", 6.0/a271 + wc0271
print "wc272Pmin=", 2.5/a272 + wc0272
print "wc272Pmax=", 6.0/a272 + wc0272
print "wc273Pmin=", 2.5/a273 + wc0273
print "wc273Pmax=", 6.0/a273 + wc0273
print "wc274Pmin=", 2.5/a274 + wc0274
print "wc274Pmax=", 6.0/a274 + wc0274

set print "-"

