from pathlib import Path

def list_files(
    root_dir: str | Path,
    ext: str = ".qml"
) -> list[str]:
    root = Path(root_dir)
    return [str(p) for p in root.rglob(f"*{ext}")]

if __name__ == "__main__":
    print(list_files("gui"))