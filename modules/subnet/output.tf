

output subnet {
    #value = "${aws_subnet.myapp-subnet1}.id"
    # w sumie to lepiej zwrocic caly obiekt niz tylko jego id - i pozniej np wyciagnac sobie z niego to co mi potrzeba np id :)
    value = "${aws_subnet.myapp-subnet1}"

}