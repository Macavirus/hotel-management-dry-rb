# Hotel Management

This little gem is a simple application to manage a hotel by checking in/checking out guests.

## Purpose

This application is mainly used as an experiment to test out the [dry-monads](https://dry-rb.org/gems/dry-monads/) and [dry-validation](https://dry-rb.org/gems/dry-validation/) libraries from [https://dry-rb.org/](https://dry-rb.org/). They allow for easier control flow through a variety of clean, functional steps that can each produce an error. Inspired by [railway-oriented-programming](https://fsharpforfunandprofit.com/rop/) from the F# community.

## Example usage:

```ruby
hotel = Hotel.new
room_manager = RoomManager.new

# create a guest and try to check them in
guest = { name: "Jan Hrach", rooms: [18, 19, 20]}

# check in a guest
# check_in_result is either a Success or Failure monad
check_in_result = CheckInGuest.new(room_manager: room_manager).call(guest)

# check out the guest
# result is either a Success or Failure monad
check_out_result = CheckOutGuest.new(room_manager: room_manager).call(guest)
```



## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
