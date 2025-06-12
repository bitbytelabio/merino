#![allow(unused_imports)]

use bencher::{Bencher, benchmark_group, benchmark_main, black_box};
use merino::*;

fn bench_pow(b: &mut Bencher) {
    // Optionally include some setup
    let x: f64 = 211.0 * 11.0;
    let y: f64 = 301.0 * 103.0;

    b.iter(|| {
        // Inner closure, the actual test
        for _ in 1..100 {
            black_box(x.powf(y).powf(x));
        }
    });
}

benchmark_group!(benches, bench_pow);
benchmark_main!(benches);
