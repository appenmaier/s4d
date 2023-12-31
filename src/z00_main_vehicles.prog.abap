*&---------------------------------------------------------------------*
*& Report z00_main_vehicles
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z00_main_vehicles.

DATA partners TYPE TABLE OF REF TO zif_00_partner.
DATA rental1 TYPE REF TO zcl_00_rental.
DATA rental2 TYPE REF TO zcl_00_rental.

DATA vehicle  TYPE REF TO zcl_00_vehicle.          " Vehicle vehicle;
*DATA(vehicle2) = NEW zcl_00_vehicle( ). "Vehicle vehicle = new Vehicle( );
DATA vehicles TYPE TABLE OF REF TO zcl_00_vehicle. " List<Vehicle> vehicles = new ArrayList<>();
DATA car      TYPE REF TO zcl_00_car.
DATA truck    TYPE REF TO zcl_00_truck.

rental1 = NEW #( 'Sixt' ).
rental2 = NEW #( 'Hertz' ).

WRITE zcl_00_vehicle=>number_of_vehicles.

TRY.
    vehicle = NEW zcl_00_car( make = 'VW' model = 'Up' number_of_seats = 4 ). " vehicle = new Car("VW", "Up", 4);
    APPEND vehicle TO vehicles.
    rental1->add_vehicle( vehicle ).
  CATCH zcx_00_inital_parameter INTO DATA(e).
    WRITE e->get_text( ).
ENDTRY.

WRITE zcl_00_vehicle=>number_of_vehicles.

TRY.
    vehicle = NEW zcl_00_truck( make = 'MAN' model = 'TGX' cargo_in_tons = 40 ). " Upcast
    APPEND vehicle TO vehicles.
    rental1->add_vehicle( vehicle ).
  CATCH zcx_00_inital_parameter INTO e.
    WRITE e->get_text( ).
ENDTRY.

WRITE zcl_00_vehicle=>number_of_vehicles.

TRY.
    vehicle = NEW zcl_00_car( make = 'Porsche' model = '911' number_of_seats = 2 ).
    APPEND vehicle TO vehicles.
    rental2->add_vehicle( vehicle ).
  CATCH zcx_00_inital_parameter INTO e.
    WRITE e->get_text( ).
ENDTRY.

WRITE zcl_00_vehicle=>number_of_vehicles.

APPEND rental1 TO partners. "Upcast
APPEND rental2 TO partners. "Upcast

" Ausgabe
LOOP AT vehicles INTO vehicle. " Dynamische Polymorphie
  WRITE / vehicle->to_string( ).
  TRY.
      car = CAST #( vehicle ). " Car car = (Car) vehicle; "Downcast
      WRITE car->number_of_seats.
    CATCH cx_sy_move_cast_error.
  ENDTRY.
  IF vehicle IS INSTANCE OF zcl_00_truck. "if (vehicle instanceof Truck truck)
    truck = CAST #( vehicle ). " Downcast
    WRITE truck->cargo_in_tons.
  ENDIF.
ENDLOOP.
