layout {
    background-color "{{ background }}"

    border {
        on
        width 1.5
        active-color "{{ accent }}"
        inactive-color "{{ color8 }}"
        urgent-color "{{ color1 }}"
    }

    focus-ring {
        off
    }

    tab-indicator {
        active-color "{{ accent }}"
        inactive-color "{{ color8 }}"
        urgent-color "{{ color1 }}"
    }

    insert-hint {
        color "{{ accent }}80"
    }
}

overview {
    backdrop-color "{{ background }}"
}

recent-windows {
    highlight {
        active-color "{{ accent }}"
        urgent-color "{{ color1 }}"
        padding 20

    }
}