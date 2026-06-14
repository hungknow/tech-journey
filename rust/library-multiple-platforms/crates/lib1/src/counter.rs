use crux_core::{render::Render, App};
use serde::{Deserialize, Serialize};

#[derive(Serialize, Deserialize)]
pub enum CounterEvent {
    Increment,
    Decrement,
    Reset,
}

#[derive(Default)]
pub struct CounterModel {
    count: i32,
}

#[derive(Serialize, Deserialize)]
pub struct CounterViewModel {
    pub count: String,
}

#[cfg_attr(feature = "typegen", derive(macros::Export))]
#[cfg_attr(feature = "typegen", uniffiexport(name = "CounterEffect"))]
#[derive(crux_core::macros::Effect)]
#[effect(app = "Counter", name = "CounterEffect")]
pub struct CounterCapabilities {
    render: Render<CounterEvent>
}

#[derive(Default)]
pub struct Counter;

impl App for Counter {
    type Event = CounterEvent;
    type Model = CounterModel;
    type ViewModel = CounterViewModel;
    type Capabilities = CounterCapabilities;

    fn update(&self, event: Self::Event, model: &mut Self::Model, caps: &Self::Capabilities) {
        match event {
            CounterEvent::Increment => model.count += 1,
            CounterEvent::Decrement => model.count -= 1,
            CounterEvent::Reset => model.count = 0,
        }

        caps.render.render();
    }

    fn view(&self, model: &Self::Model) -> Self::ViewModel {
        CounterViewModel {
            count: format!("Count is: {}", model.count),
        }
    }
}

#[cfg(test)]
mod tests {
    use crux_core::{assert_effect, testing::AppTester};

    use super::*;
    #[test]
    fn renders() {
        let app = AppTester::<Counter, _>::default();
        let mut model = CounterModel::default();

        let update = app.update(CounterEvent::Reset, &mut model);

        // Check update asked us to `Render`
        assert_effect!(update, CounterEffect::Render(_));
    }

    #[test]
    fn show_initial_count() {
        let app = AppTester::<Counter, _>::default();
        let model = CounterModel::default();

        let actual_view = app.view(&model).count;
        let expected_view = "Count is: 0";
        assert_eq!(actual_view, expected_view);
    }

}