mod systems {
    pub mod actions;
}

mod models;
use systems::actions::actions::WorldState;
use systems::actions::actions::ActionsImpl;
use starknet::contract_address_const;
fn main() -> WorldState {
    let mut world = WorldState {
        positions: Default::default(),
        moves: Default::default(),
    };
    let player = contract_address_const::<0>();
    ActionsImpl::spawn(ref world,player);
    ActionsImpl::move(ref world,player,models::Direction::Up);
    ActionsImpl::move(ref world,player,models::Direction::Right);
    let position = world.positions.get(player.into()).deref();
    println!("{:?}",position);
    world
}